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
//import RealmSwift

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
    
    static func downloadBooks(sessionID: String, audioBook: AudioBook, downloadFast: Bool, listener: @escaping ()->Void ){
        
        var chaptersDownloaded = 0;
        
        for var id in downloadFast ? audioBook.AudioIDS.FileFast : audioBook.AudioIDS.FileNormal{
            
            if let audioUrl = URL(string: getFileDownloadUrl(audioID: id, sessionID: sessionID)) {
                
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(id + ".mp3")
                                
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else {return }
                    do {
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                    chaptersDownloaded+=1;
                    if(chaptersDownloaded == audioBook.AudioIDS.FileFast.count){
                        DispatchQueue.main.async {
                            saveBookInfo(audioBook: audioBook)
                            listener()
                        }
                    }
                }).resume()
                
            }
        }
    }
    
    private static func saveBookInfo(audioBook: AudioBook){
        /*let realm = try! Realm();
        
        //Checking if a book entry exists
        if(realm.objects(AudioBook).filter("Title == %@", audioBook.Title).count == 0){
            print("book does not exist")
            try! realm.write {
                realm.add(audioBook)
            }
        }else{
            print("book DOES exist")
        }*/
    }
    
    static func getFileDownloadUrl(audioID: String, sessionID: String) -> String{
        let url1 = "http://elvis.labiblioteka.lt/publications/getmediafile/" + audioID
        let url2 = "/" + audioID + ".mp3?session_id=" + sessionID
        return url1 + url2
    }
    
    static func eraseBooks(audioBookIDs: [String], listener: @escaping ()->Void ){
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        for var id in audioBookIDs{
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(id + ".mp3")
            
            do {
                try FileManager.default.removeItem(at: destinationUrl.asURL())
            }
            catch let error as NSError {
            }
            
            listener()
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
    
    
    static func NewestBooks(haveDisabilities:String, onFinishListener: @escaping (_ books : [AudioBook]) -> Void){
        
        var books: [AudioBook] = []
        let url = BaseURL + "newestPublications.php";
        let json : Parameters = ["HaveDisabilities": haveDisabilities]
        
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
                    let FilePosition = Array(swiftyJsonVar[x]["FilePosition"].arrayObject as! [String])
                    //Back end is written badly, because it returns fileIds in random position. Method below rearanges normal and fast files for easy usage.
                    let audioIDS: AudioBookIDS = PositionIDSCorrectly(fileCount: FileCount, fileIDS: FileIDs, filePosition: FilePosition)
                  
                    books.append(AudioBook(id: ID,title: Title,realeaseDate: ReleaseDate,authorID: AuthorID,authorFirstName: AuthorFirstName,authorLastName: AuthorLastName,speakerId: SpeakerID,speakerFirstName: SpeakerFirstName,speakerLastName: SpeakerLastName, publicationNumber: PublicationNumber, fileCount: FileCount, audioIDS: audioIDS))
                }
                //print("is utilsu: ", books.count)
                onFinishListener(books)
            }else{
                onFinishListener(books)
            }
        }
    }
    
    static func PositionIDSCorrectly(fileCount: Int, fileIDS: [String],filePosition: [String]) -> AudioBookIDS{
        let totalCount: Int = fileCount
        let actualCount = totalCount/2
        
        var filesNormal: [String] = []
        var filesFast: [String] = []
        
        var secondTime: Bool = false
        var lastIndex: Int = -1
    
        for i in 1...actualCount{
            for x in 0...totalCount-1{
                if(String(i) == filePosition[x] && x != lastIndex){
                    lastIndex = x
                    if(!secondTime){
                        filesNormal.append(fileIDS[x])
                        secondTime = true
                    }else{
                        filesFast.append(fileIDS[x])
                        break
                    }
                }
                
            }
            secondTime = false
            lastIndex = -1
        }
        return AudioBookIDS(fileIDs: filesNormal, fileIsFast: filesFast)
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
                    let FilePosition = Array(swiftyJsonVar[x]["FilePosition"].arrayObject as! [String])
                    let audioIDS: AudioBookIDS = PositionIDSCorrectly(fileCount: FileCount, fileIDS: FileIDs, filePosition: FilePosition)
                    
                    books.append(AudioBook(id: ID,title: Title,realeaseDate: ReleaseDate,authorID: AuthorID,authorFirstName: AuthorFirstName,authorLastName: AuthorLastName,speakerId: SpeakerID,speakerFirstName: SpeakerFirstName,speakerLastName: SpeakerLastName, publicationNumber: PublicationNumber, fileCount: FileCount, audioIDS: audioIDS))
                }
                onFinishListener(books)
            }else{
                onFinishListener(books)
            }
        }
    }

}




