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
import RealmSwift

let taskID : Int = 0;


public enum LoginError{
    case NetworkError
    case InvalidCredentials
}


class DatabaseUtils{
    
    static let BaseURL = "http://elvis.labiblioteka.lt/app/"
    static let LoginUrl = BaseURL + "login.php"
    static let SendMessageUrl = BaseURL + "messageSend.php"
    static let GetMessagesUrl = BaseURL + "messagesReceived.php"
    static let GetNewsUrl = BaseURL + "news.php"
    
    static func fetchNews(onFinishListener: @escaping (Bool, [NewsItem]?) -> Void){
        
        let json : Parameters = [
            "ss": "sds"
        ]
        
        AF.request(GetNewsUrl, method: .post, parameters: json, encoding: URLEncoding.httpBody, headers:nil).responseJSON{
            response in
            
            guard response.error == nil, response.result.value != nil else{
                print("error: " + response.error!.localizedDescription)
                onFinishListener(false, nil)
                return
            }
            
            let jsonArr = JSON(response.result.value!)
            
            var newsItems: [NewsItem] = []
            
            for (_, subJson) in jsonArr {
                let description = Utils.getAttributedString(string: subJson["Description"].string!)!
                let name = subJson["Name"].string!
                print(name)
                let ID = subJson["ID"].string!
                let isActive = subJson["IsActive"].string!
                let activationDateFrom = subJson["ActivationDateFrom"].string!
                let activationDateTo = subJson["ActivationDateTo"].string!
                
                newsItems.append(NewsItem(ID: ID, name: name, description: description, isActive: isActive, activationDateFrom: activationDateFrom, activationDateTo: activationDateTo))
            }
            onFinishListener(true, newsItems)
        }
        
    }
    
    
    
    static func Login(username: String, password: String, onFinishLoginListener:@escaping (_ success: Bool, _ error: LoginError?) -> Void ){
        
        
        let json : Parameters = [
            "UserName": username,
            "Password": password
        ]
        AF.request(LoginUrl, method: .post, parameters: json, encoding: URLEncoding.httpBody, headers:nil).responseJSON{
            response in
            
            guard response.error == nil else{
                onFinishLoginListener(false, .NetworkError)
                return
            }
            
            if let JSON = response.result.value as? NSDictionary{
                print(JSON)
                let disabilities = JSON["HaveDisabilities"] as! String
                let userID = JSON["ID"] as! String
                GetCookie(username: username, password: password, disabilities: disabilities, userID: userID, onFinishLoginListener: {(success, sessionIDNew) in
                    onFinishLoginListener(success, nil)
                })
            }else{
                onFinishLoginListener(false, LoginError.InvalidCredentials)
            }
        }
    }
    
    static func sendMessageToAdmins(topic: String, body: String, onFinishListener: @escaping (Bool) -> Void){
        let userID = Utils.readFromSharedPreferences(key: "userID")
        
        let json : Parameters = [
            "ID": userID,
            "Subject": topic,
            "Content": body
        ]
        
        AF.request(SendMessageUrl, method: .post, parameters: json, encoding: URLEncoding.httpBody, headers:nil).responseString{ response in
            
            guard response.error == nil else{
                onFinishListener(false)
                return
            }
            
            
            onFinishListener(true)
        }
    }
    
    static func getMessages(onFinishListener: @escaping (Bool, [Message]?) -> Void){
        
        let userID = Utils.readFromSharedPreferences(key: "userID")
        let json : Parameters = [
            "userID": userID
        ]
        
        AF.request(GetMessagesUrl, method: .post, parameters: json, encoding: URLEncoding.httpBody, headers:nil).responseJSON{ response in
            
            guard response.error == nil else{
                onFinishListener(false, nil)
                return
            }
            
            guard let responseVal = response.result.value else{
                onFinishListener(false, nil)
                return
            }
            
            let jsonArr = JSON(responseVal)
            
            var messages: [Message] = []
            
            for (_, subJson) in jsonArr {
                
                let content = subJson["Content"].string!
                let date = Utils.getDateFromString(date: subJson["SendingDate"].string!)
                let subject = subJson["Subject"].string!
                let linkedPublicationID = subJson["LinkedPublicationID"].int
                let parentMessageID = subJson["ParentMessageID"].int
                let messageID = subJson["ID"].string!
                
                let message: Message = Message(content: content, subject: subject, parentMessageID: parentMessageID, date: date, LinkedPublicationID: linkedPublicationID, messageID: messageID)
                
                messages.append(message)
            }
            
            onFinishListener(true, messages)
            
            
            
        }
        
        
    }
    
    static func downloadBooks(sessionID: String, audioBook: AudioBook, downloadFast: Bool, updateListener: @escaping (Int, Int, Bool)->Void ){
        
        //In case a previus download of this book was interrupted, removing the leftover files
        eraseBooks(audioBookIDs: downloadFast ? audioBook.FileFastIDS : audioBook.FileNormalIDS) {
            
            var chaptersDownloaded = 0 //The number of chapers. Used to display progress
            var tasks: [URLSessionTask] = [] //Storing all URLSession tasks, so they can be cancelled later
            
            //Looping either through fast file id's or through normal file id's based on parameters
            for id in downloadFast ? (audioBook.FileFastIDS) : audioBook.FileNormalIDS{
                
                //Attempting to create the url to mp3 file
                guard let audioUrl = URL(string: getFileDownloadUrl(audioID: id, sessionID: sessionID)) else{
                    updateListener(0, audioBook.FileNormalIDS.count, false)
                    
                    tasks.first?.cancel()
                    return
                }
                
                //Finding the path to documents directory so we can move the audio files there later
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                //Creating the final URL of the audio file
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(id + ".mp3")
                
                //Creating URLSession and appending it to the array
                tasks.append(
                    URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                        
                        //Checking for unexpected scenarios
                        guard let location = location, error == nil, response != nil else {
                            
                            //We do not want to call the listener if the task has been cancelled
                            if(error!.localizedDescription != "cancelled"){
                                updateListener(chaptersDownloaded, audioBook.FileNormalIDS.count, false)
                                print(error!.localizedDescription)
                                tasks.first?.cancel()
                            }
                            return
                        }
                        
                        //If the content length is 0, it's most likely due to expired session ID
                        guard response?.expectedContentLength != 0 else{
                            //In such a case, we want to cancel the ongoing urlsession
                            tasks.first?.cancel()
                            //...and retrieve a new SessionID
                            let username = Utils.readFromSharedPreferences(key: "username") as! String
                            let password = Utils.readFromSharedPreferences(key: "password") as! String
                            let userID = Utils.readFromSharedPreferences(key: "userID") as! String
                            let disabilities = Utils.readFromSharedPreferences(key: "haveDisabilities") as! String
                            GetCookie(username: username, password: password, disabilities: disabilities, userID: userID, onFinishLoginListener: { (success, sessionIDNew) in
                                
                                //Downloading books with the new sessionID
                                guard success, let sessionIDNew = sessionIDNew else{
                                    //Due to unknown reason the cookie was unable to be retrieved (perhaps the user has changed their password)
                                    updateListener(chaptersDownloaded, audioBook.FileNormalIDS.count, false)
                                    return
                                }
                                downloadBooks(sessionID: sessionIDNew, audioBook: audioBook, downloadFast: downloadFast, updateListener: updateListener)
                            })
                            return
                        }
                        
                        do {
                            //Moving audio file from temp folder to documents folder
                            try FileManager.default.moveItem(at: location, to: destinationUrl)
                        } catch let error as NSError {
                            print(destinationUrl)
                            print(error.localizedDescription)
                            updateListener(chaptersDownloaded, audioBook.FileNormalIDS.count, false)
                            tasks.first?.cancel()
                            return;
                        }
                        
                        DispatchQueue.main.async {
                            //If no errors occured, the file has been downloaded successfully. Increasing the downloaded chapter count
                            chaptersDownloaded+=1;
                            if(chaptersDownloaded == audioBook.FileFastIDS.count){
                                saveBookInfo(audioBook: audioBook)
                            }
                            
                            //Removing the current task from the list and starting another one
                            tasks.remove(at: 0)
                            if(tasks.count > 0){
                                tasks.first?.resume()
                            }
                            updateListener(chaptersDownloaded, audioBook.FileFastIDS.count, true)
                        }
                    }))
            }
            
            //Starting the first task
            tasks.first?.resume()
        }
    }
    
    public static func getDownloadedBooks() -> Results<AudioBook> {
        
        let realm = try! Realm()
        let results: Results<AudioBook> = realm.objects(AudioBook.self)
        return results
        
    }
    
    
    private static func saveBookInfo(audioBook: AudioBook){
        
        print(Realm.Configuration.defaultConfiguration.fileURL!.path)
        DispatchQueue.main.async {
            let realm = try! Realm()
            try! realm.write {
                if(realm.objects(AudioBook.self).filter("Title == %@", audioBook.Title).count == 0){
                    print("book does not exist")
                    realm.add(audioBook)
                }
            }
            
        }
    }
    
    public static func deleteBookInfo(audioBook: AudioBook){
        DispatchQueue.main.async {
            let realm = try! Realm()
            //let objToRemove = realm.objects(AudioBook.self).filter("ID=%@",audioBook.ID)
            try! realm.write {
                realm.delete(audioBook)
            }
        }
    }
    
    static func getFileDownloadUrl(audioID: String, sessionID: String) -> String{
        let url1 = "http://elvis.labiblioteka.lt/publications/getmediafile/" + audioID
        let url2 = "/" + audioID + ".mp3?session_id=" + sessionID
        return url1 + url2
    }
    
    static func eraseBooks(audioBookIDs: List<String>, listener: @escaping ()->Void ){
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        for id in audioBookIDs{
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(id + ".mp3")
            
            do {
                try FileManager.default.removeItem(at: destinationUrl.asURL())
            }
            catch {
            }
            
        }
        listener()
        
    }
    
    static func GetCookie(username: String, password: String, disabilities: String, userID: String,onFinishLoginListener:@escaping (_ success: Bool, _ sessionID: String?) -> Void){
        let url = "http://elvis.labiblioteka.lt/home/loginpassword/login"
        let json : Parameters = [
            "Records[0][UserName]": username,
            "Records[0][Password]": password
        ]
        AF.request(url, method: .post, parameters: json, encoding: URLEncoding.httpBody, headers:nil).responseString{
            response in
            
            guard response.error == nil else{
                onFinishLoginListener(false, nil)
                return
            }
            
            for cookie in HTTPCookieStorage.shared.cookies! {
                if(cookie.name=="PHPSESSID"){
                    print(cookie.name + " - " + cookie.value)
                    Utils.writeToSharedPreferences(key: "username", value: username)
                    Utils.writeToSharedPreferences(key: "password", value: password)
                    Utils.writeToSharedPreferences(key: "userID", value: userID)
                    Utils.writeToSharedPreferences(key: "haveDisabilities", value: disabilities)
                    Utils.writeToSharedPreferences(key: "sessionID", value: cookie.value)
                    onFinishLoginListener(true, cookie.value)
                    return
                }
            }
            onFinishLoginListener(false, nil)
            return
            
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
                    
                    let audioIDS: AudioBookIDS = PositionIDSCorrectly(fileCount: FileCount, fileIDS: FileIDs, filePosition: FilePosition)
                    let FileFastIDS = List<String>()
                    let FileNormalIDS = List<String>()
                    
                    for x in audioIDS.FileNormal{
                        FileNormalIDS.append(x)
                    }
                    
                    for y in audioIDS.FileFast{
                        FileFastIDS.append(y)
                    }
                    
                    books.append(AudioBook(id: ID,title: Title,realeaseDate: ReleaseDate,authorID: AuthorID,authorFirstName: AuthorFirstName,authorLastName: AuthorLastName,speakerId: SpeakerID,speakerFirstName: SpeakerFirstName,speakerLastName: SpeakerLastName, publicationNumber: PublicationNumber, fileCount: FileCount, fileIdsNormal: FileNormalIDS, fileIdsFast: FileFastIDS))
                    
                    
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
                    let FileFastIDS = List<String>()
                    let FileNormalIDS = List<String>()
                    
                    for y in audioIDS.FileNormal{
                        FileNormalIDS.append(y)
                    }
                    for y in audioIDS.FileFast{
                        FileFastIDS.append(y)
                    }
                    
                    books.append(AudioBook(id: ID,title: Title,realeaseDate: ReleaseDate,authorID: AuthorID,authorFirstName: AuthorFirstName,authorLastName: AuthorLastName,speakerId: SpeakerID,speakerFirstName: SpeakerFirstName,speakerLastName: SpeakerLastName, publicationNumber: PublicationNumber, fileCount: FileCount, fileIdsNormal: FileFastIDS, fileIdsFast: FileNormalIDS))
                }
                onFinishListener(books)
            }else{
                onFinishListener(books)
            }
        }
    }
    
}




