//
//  DatabeUtils.swift
//  Elvis
//
//  Created by Benas on 23/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let BaseURL: String = "http://elvis.labiblioteka.lt/app/";

class DatabaseUtils{

 
    static func Login(username: String, password: String, onFinishLoginListener:@escaping (_ success: Bool) -> Void ){
 
        let url = "http://elvis.labiblioteka.lt/app/login.php"
        let json : Parameters = [
            "UserName": username,
            "Password": password
        ]
        AF.request(url, method: .post, parameters: json, encoding: URLEncoding.httpBody, headers:nil).responseJSON{
            response in
                if let JSON = response.result.value as? NSDictionary{
                    print(JSON)
                    let disabilities = JSON["HaveDisabilities"] as! String
                    GetCookie(username: username, password: password, disabilities: disabilities, onFinishLoginListener: onFinishLoginListener)
                }else{
                    onFinishLoginListener(false)
            }
        }
    }
    
    static func GetCookie(username: String, password: String, disabilities: String, onFinishLoginListener:@escaping (_ success: Bool) -> Void){
        let url = "http://elvis.labiblioteka.lt/home/loginpassword/login"
        let json : Parameters = [
            "Records[0][UserName]": username,
            "Records[0][Password]": password
        ]
        AF.request(url, method: .post, parameters: json, encoding: URLEncoding.httpBody, headers:nil).responseString{
            response in
            for cookie in HTTPCookieStorage.shared.cookies! {
                if(cookie.name=="PHPSESSID"){
                    print(cookie.name + " - " + cookie.value)
                    Utils.writeToSharedPreferences(key: "username", value: username)
                    Utils.writeToSharedPreferences(key: "password", value: password)
                    Utils.writeToSharedPreferences(key: "haveDisabilities", value: disabilities)
                    Utils.writeToSharedPreferences(key: "sessionID", value: cookie.value)
                    onFinishLoginListener(true)
                    return
                }
            }
            
        }
    }

    static func SearchBooks(haveDisabilities:String, title: String, name: String, announcingPerson: String, anyWord: String, onFinishListener:
        @escaping (_ books : [AudioBook]) -> Void){
        
        var books: [AudioBook] = []
        
        let url = BaseURL + "search.php";
        let json : Parameters = [
            "HaveDisabilities": haveDisabilities,
            "title": title,
            "name" : name,
            "announcingPerson": announcingPerson,
            "anyWord" : anyWord]
        
        AF.request(url, method: .post, parameters: json, encoding: URLEncoding.httpBody, headers:nil).responseJSON{
            response in
            if((response.result.value) != nil) {
                //Gets json
                let swiftyJsonVar = JSON(response.result.value!)
                if(swiftyJsonVar.isEmpty){
                    onFinishListener(books)
                    return
                }
                //Write data to AudioBook object
                for x in 0..<(swiftyJsonVar.count-1){
                    let ID = swiftyJsonVar[x]["ID"].string ?? ""
                    let Title = swiftyJsonVar[x]["Title"].string ?? ""
                    let ReleaseDate = swiftyJsonVar[x]["ReleaseDate"].string ?? ""
                    let AuthorID = swiftyJsonVar[x]["AuthorID"].string ?? ""
                    let AuthorFirstName = swiftyJsonVar[x]["AuthorFirstName"].string ?? ""
                    let AuthorLastName = swiftyJsonVar[x]["AuthorLastName"].string ?? ""
                    let SpeakerID = swiftyJsonVar[x]["SpeakerID"].string ?? ""
                    let SpeakerFirstName = swiftyJsonVar[x]["SpeakerFirstName"].string ?? ""
                    let SpeakerLastName = swiftyJsonVar[x]["SpeakerLastName"].string ?? ""
                    let PublicationNumber = swiftyJsonVar[x]["PublicationNumber"].int ?? 0
                    let FileCount = swiftyJsonVar[x]["FileCount"].int ?? 0
                    let FileIDs = Array(swiftyJsonVar[x]["FileIDs"].arrayObject as! [String])
                    let FileIsFast = Array(swiftyJsonVar[x]["FileIsFast"].arrayObject as! [String])
                    let FilePosition = Array(swiftyJsonVar[x]["FilePosition"].arrayObject as! [String])
                    
                    books.append(AudioBook(id: ID,title: Title,realeaseDate: ReleaseDate,authorID: AuthorID,authorFirstName: AuthorFirstName,authorLastName: AuthorLastName,speakerId: SpeakerID,speakerFirstName: SpeakerFirstName,speakerLastName: SpeakerLastName, publicationNumber: PublicationNumber, fileCount: FileCount, fileIDs: FileIDs, fileIsFast: FileIsFast, filePosition: FilePosition))
                }
                //print("is utilsu: ", books.count)
                onFinishListener(books)
            }else{
                onFinishListener(books)
            }
        }
    }

}




