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
var tasks: [URLSessionTask] = [] //Storing all URLSession tasks, so they can be cancelled later

public enum LoginError{
    case NetworkError
    case InvalidCredentials
}
public enum UniqueIDRequestError{
    case InvalidConnection
    case UnexpectedServerResponse
}

class DatabaseUtils{
    
    static let BaseUrl = "http://elvis.labiblioteka.lt/"
    static let BaseApiUrl = BaseUrl + "app/"
    static let LoginUrl = BaseApiUrl + "login.php"
    static let SendMessageUrl = BaseApiUrl + "messageSend.php"
    static let GetMessagesUrl = BaseApiUrl + "messagesReceived.php"
    static let RegistrationUrl = BaseUrl + "registration/password"
    static let GetNewsUrl = BaseApiUrl + "news.php"
    
    private static func getListenHistoryRealm() -> Realm{
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("listeningHistory" + ".realm")
        
        print(documentsDirectoryURL.absoluteString)
        
        let realm = try! Realm(fileURL: destinationUrl)
        return realm
    }
    
    static func addToRecentsList(book: AudioBook){
        DispatchQueue.main.async {
            let realm = getListenHistoryRealm()
            
            let bookCopy = AudioBook(value: book)
            
            do  {
                try realm.write{
                    //If book exists -> updates - otherwise -> adds a new book
                    bookCopy.created = Date()
                    realm.add(bookCopy, update: true)
                }
                //Checking if there are more than 10 books -> If yes -> Delete 11th book
                let results: Results<AudioBook> = getRecentBooks()
                
                if(results.count>10){
                    try realm.write{
                        //Deleting 11th book
                        realm.delete(results[10])
                    }
                }
            }catch let error{
                print(error)
            }
        }
    }
    
    
    static func getTimestampAndID(listener: @escaping (_ timestamp: String?, _ uniqueID: String?, _ sessionID: String? , _ error: UniqueIDRequestError?) -> Void){
        
        //Sending GET request to the registration page without any params
        AF.request(RegistrationUrl, method: .get, parameters: .none, encoding: URLEncoding.httpBody, headers:nil).responseString{
            response in
            
            guard response.error == nil, response.result.value != nil else{
                //This error is most likely due to connection issues.
                listener(nil, nil, nil, UniqueIDRequestError.InvalidConnection)
                return
            }
            
            let result = response.result.value!
            
            //The regex code that finds timestamp value in the html page
            let timestampRegex = """
            name=\\"timestamp\\" value=\\"(.*?)"
            """
            
            //The regex code that finds unique ID in the html page
            let uniqueIDRegex = """
            (?<=ID]\" value=\").{40}
            """
            
            //Performing the actual search with the regex code
            let uniqueIDSearchResults = result.matchingStrings(regex: uniqueIDRegex)
            let timestampSearchResults = result.matchingStrings(regex: timestampRegex)
            
            guard uniqueIDSearchResults.count != 0, timestampSearchResults.count != 0 else{
                //Returning an error if timestamp could not be found. If this happens, it is likely that the server has been altered
                listener(nil, nil, nil, UniqueIDRequestError.UnexpectedServerResponse)
                return
            }
            
            guard uniqueIDSearchResults[0].count != 0, timestampSearchResults[0].count != 0 else{
                //Returning an error if unique ID could not be found. If this happens, it is likely that the server has been altered
                listener(nil, nil, nil, UniqueIDRequestError.UnexpectedServerResponse)
                return
            }
            
            //Getting the actual values from the regex search
            let uniqueID = uniqueIDSearchResults[0][0]
            let timestamp = timestampSearchResults[0][1]
            
            var sessionID: String? = nil
            
            //Attempting to retrieve session ID
            for cookie in HTTPCookieStorage.shared.cookies! {
                if(cookie.name=="PHPSESSID"){
                    sessionID = cookie.value
                    break
                }
            }
            
            guard sessionID != nil else{
                //If the session ID could not be retrieved, it is likely that the server has been altered. returning an error.
                listener(nil, nil, nil, UniqueIDRequestError.UnexpectedServerResponse)
                return
            }
            
            //If all goes well, returning the values with error being nil
            listener(timestamp, uniqueID, sessionID, nil)
            
        }
        
    }
    
    enum Gender: String{
        case Moteris = "Female"
        case Vyras = "Male"
    }
    
    enum RegistrationError{
        case OutdatedClient
        case InvalidConnection
        case InvalidInput(details: String)
    }
    
    static func register(firstName: String!, lastName: String!, personalCode: String!, birthday: Date!, education: Int!, emailAddress: String!, mobilePhoneNumber: String!, muncipality: Int!, leagueDescription: String!, username: String!, password: String!, repeatedPassword: String!, gender: Gender!, status: Int!, haveDisabilities: Bool!, isLabUser: Bool!, photoID: UIImage, photoDisabilityDocument: UIImage, acceptConditions: Bool, acceptCommentConditions: Bool, _ listener : @escaping (_ error: RegistrationError?) -> Void){
        
        //Getting timestamp, unique ID and session ID, since it will be used later
        getTimestampAndID(listener: {
            timestamp, uniqueID, sessionID, error in
            
            guard error == nil, let timestamp = timestamp, let uniqueID = uniqueID, let sessionID = sessionID else{
                
                switch error! {
                    
                case UniqueIDRequestError.UnexpectedServerResponse:
                    //This may occur if the server side was altered, and our client is incapable of receiving unique ID, session ID or timestamp
                    listener(RegistrationError.OutdatedClient)
                    return
                case UniqueIDRequestError.InvalidConnection:
                    //This error will most likely occur due to connectivity issues
                    listener(RegistrationError.InvalidConnection)
                    return
                }
            }
            
            //Creating the necessary headers to emulate a browser
            let headers: HTTPHeaders = [
                "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
                "accept-encoding":"gzip, deflate",
                "accept-language":"lt,en-US;q=0.9,en;q=0.8,ru;q=0.7,pl;q=0.6",
                "cache-control":"max-age=0",
                "content-length":"2117",
                "content-type":"multipart/form-data; boundary=----WebKitFormBoundaryuiQAABOqpG8HW2oy; charset=utf-8",
                "cookie":"frint-endcontrast=contrastNormal; frint-endfont=12; PHPSESSID=\(sessionID)",
                "dnt":"1",
                "host":"elvis.labiblioteka.lt",
                "origin":"http://elvis.labiblioteka.lt",
                "proxy-connection":"keep-alive",
                "referer":"http://elvis.labiblioteka.lt/registration/password",
                "upgrade-insecure-requests":"1",
                "user-agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36"
                
            ]
            
            //These are used to compute the month, year and day from date object
            let calendar = Calendar.current
            let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: birthday)
            
            //Array, containing all the data (except for images)
            let data: [String: String] = [
                "timestamp": timestamp,
                "Records[0][UniqueID]": uniqueID,
                "Records[0][FirstName]": firstName,
                "Records[0][LastName]":lastName,
                "Records[0][PersonalCode]": personalCode,
                "Records[0][BirthdayYear]": String(components.year!),
                "Records[0][BirthdayMonth]": String(components.month!),
                "Records[0][BirthdayDay]": String(components.day!),
                "Records[0][EducationID]": String(education),
                "Records[0][EmailAddress]": emailAddress,
                "Records[0][MobilePhoneNumber]": mobilePhoneNumber,
                "Records[0][MunicipalityID]": String(muncipality),
                "Records[0][LeagueDescription]": leagueDescription,
                "Records[0][UserName]": username,
                "Records[0][Password]": password,
                "Records[0][RepeatedPassword]": repeatedPassword,
                "Records[0][Gender]": gender.rawValue,
                "Records[0][Status][]": String(status),
                "Records[0][HaveDisabilities]": haveDisabilities ? "1" : "0",
                "Records[0][IsLabUser]": isLabUser ? "1" : "0",
                "Records[0][Conditions]": acceptConditions ? "1" : "0",
                "Records[0][CommentConditions]": acceptCommentConditions ? "1" : "0",
                "Action[Registration]": "Registruotis"
            ]
            
            //Array, containing image data
            let arrImage: [UIImage] = [
                photoID,
                photoDisabilityDocument
            ]
            
            //Performing the multipart reuqest task using AlamoFire
            AF.upload(multipartFormData: { (multipartFormData) in
                
                //Appending all the body fields as multipart entities
                for (key, value) in data {
                    multipartFormData.append((value).data(using: String.Encoding.utf8)!, withName: key)
                }
                
                //Appending all the image fields as multipart entities
                for (index, img) in arrImage.enumerated() {
                    guard let imgData = img.jpegData(compressionQuality: 1) else { return }
                    multipartFormData.append(imgData, withName: "files[]", fileName: "upload\(index)" + ".jpeg", mimeType: "image/jpeg")
                }
                
                
            },usingThreshold: UInt64.init(),
              to: RegistrationUrl,
              method: .post,
              headers: headers).responseString(encoding: String.Encoding.utf8){ response in
                
                guard response.error == nil, let result = response.result.value else{
                    //This error is most likely caused by connectivity issues.
                    listener(RegistrationError.InvalidConnection)
                    return
                }
                
                //The regex code that finds the success message in the page
                let successMessageRegex =
                """
                Prašymas suteikti prieigą sėkmingai gautas. Patvirtinimą gausite el. paštu
                """
                
                //Performing the actual search with the regex code
                let successMessageSearchResult = result.matchingStrings(regex: successMessageRegex)
                
                if(successMessageSearchResult.count > 0){
                    //Success message was found, the registration is successful
                    listener(nil)
                    return
                }else{
                    //The regex code that finds the error message in the page
                    let errorMessageRegex = "alert\\(\\'([\\s\\S]*?)\\'\\)"
                    
                    //Performing the regex search
                    let errorMessageSearchResult = result.matchingStrings(regex: errorMessageRegex)
                    
                    //If no regex result groups were found
                    guard errorMessageSearchResult.count > 0 else{
                        //Unexpected response from server: neither success nor error message exists.
                        listener(RegistrationError.OutdatedClient)
                        return
                    }
                    
                    //If no regex result string in the first group was found
                    guard errorMessageSearchResult[0].count > 1 else{
                        //Unexpected response from server: neither success nor error message exists.
                        listener(RegistrationError.OutdatedClient)
                        return
                    }
                    
                    //Getting the final error message, and subtracting the '\n' from the end
                    let errorMessage = String(errorMessageSearchResult[0][1].dropLast().dropLast())
                    
                    //Reporting the error to the final listener
                    listener(RegistrationError.InvalidInput(details: errorMessage))
                }
            }
            
        })
    }
    
    public static func getRecentBooks() -> Results<AudioBook> {
        
        let realm = getListenHistoryRealm()
        let results: Results<AudioBook> = realm.objects(AudioBook.self).sorted(byKeyPath: "created", ascending: false)
        return results
        
    }
    
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
        let userID = Utils.readFromSharedPreferences(key: "userID") as! String
        let username = Utils.readFromSharedPreferences(key: "username") as! String
        
        let json : Parameters = [
            "ID": userID,
            "Subject": topic,
            "Content": body + ". Naudotojo vardas:" + username + ", Naudotojo ID:" + userID
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
    
    static func clearData(){
        //Removing username, password and session ID from shared preferences
        Utils.deleteFromSharedPreferences(key: "username")
        Utils.deleteFromSharedPreferences(key: "password")
        Utils.deleteFromSharedPreferences(key: "sessionID")
        
        let historyRealm = getListenHistoryRealm()
        //Clearing user's listening history
        try! historyRealm.write {
            historyRealm.deleteAll()
        }
        let booksRealm = try! Realm()
        //Erasing book audio files
        for audioBook in booksRealm.objects(AudioBook.self){
            eraseBooks(audioBookIDs: audioBook.FileNormalIDS, listener: {})
            eraseBooks(audioBookIDs: audioBook.FileFastIDS, listener: {})
        }
        //Deleting book info, stored in the realm
        try! booksRealm.write {
            booksRealm.deleteAll()
        }
    }
    
    static func cancelDownloadingBook(finishListener: @escaping () -> Void){
        
        //Canceling all download tasks
        for x in 0...tasks.count - 1 {
            tasks[x].suspend()
            tasks[x].cancel()
        }
        tasks = []
        
        finishListener()
    }
    
    
    static func downloadBooks(sessionID: String, audioBook: AudioBook, downloadFast: Bool, updateListener: @escaping (Int, Int, Bool)->Void ){
        
        //In case a previus download of this book was interrupted, removing the leftover files
        eraseBooks(audioBookIDs: downloadFast ? audioBook.FileFastIDS : audioBook.FileNormalIDS) {
            
            var chaptersDownloaded = 0 //The number of chapers. Used to display progress
            tasks = []
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
                                let audioBookNew: AudioBook = audioBook
                                saveBookInfo(audioBook: audioBookNew)
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
    
    
    static func NewestBooks(haveDisabilities:String, onFinishListener: @escaping ([AudioBook], Bool) -> Void){
        
        var books: [AudioBook] = []
        let url = BaseApiUrl + "newestPublications.php";
        let json : Parameters = ["HaveDisabilities": haveDisabilities]
        
        AF.request(url, method: .post, parameters: json, encoding: URLEncoding.httpBody, headers:nil).responseJSON{
            response in
            
            //Failure
            guard response.result.value != nil else{
                onFinishListener(books, false)
                return
            }
            //Gets json
            let swiftyJsonVar = JSON(response.result.value!)
            if(swiftyJsonVar.isEmpty){
                onFinishListener(books, false)
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
                let FileIsFast = Array(swiftyJsonVar[x]["FileIsFast"].arrayObject as! [String])
                
                let audioIDS: AudioBookIDS = PositionIDSCorrectly(fileCount: FileCount, fileIDS: FileIDs, filePosition: FilePosition, fileIsFast: FileIsFast)
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
            onFinishListener(books, true)
            
        }
    }
    
    
    
    static func PositionIDSCorrectly(fileCount: Int, fileIDS: [String], filePosition: [String], fileIsFast: [String]) -> AudioBookIDS{
        let totalCount: Int = fileCount
        var actualCount: Int = 0
        if(totalCount==1){
            actualCount = totalCount
        }else{
            actualCount = totalCount/2
        }
        
        
        var filesNormal: [String] = []
        var filesFast: [String] = []
        
        var lastIndex: Int = -1
       
        if(actualCount < 1){
            print("Actual count", actualCount)
            print("Total count", totalCount)
            print("Normal FileIDS", fileIDS)
            
        }
        
        for i in 1...actualCount{
            for x in 0...totalCount-1{
                if(String(i) == filePosition[x] && x != lastIndex){
                    lastIndex = x
                    if(Int(fileIsFast[x]) == 0){
                        filesNormal.append(fileIDS[x])
                    }else{
                        filesFast.append(fileIDS[x])
                    }
                }
            }
            lastIndex = -1
        }
        return AudioBookIDS(fileIDs: filesNormal, fileIsFast: filesFast)
    }
    
    
    
    static func SearchBooks(haveDisabilities:String, title: String, name: String, announcingPerson: String, anyWord: String, onFinishListener:
        @escaping ([AudioBook], Bool) -> Void){
        
        var books: [AudioBook] = []
        
        let url = BaseApiUrl + "search.php";
        let json : Parameters = [
            "HaveDisabilities": haveDisabilities,
            "title": title,
            "name" : name,
            "announcingPerson": announcingPerson,
            "anyWord" : anyWord]
        
        AF.request(url, method: .post, parameters: json, encoding: URLEncoding.httpBody, headers:nil).responseJSON{
            response in
            
            //Failure
            guard response.result.value != nil else{
                onFinishListener(books, false)
                return
            }
            
            //Gets json
            let swiftyJsonVar = JSON(response.result.value!)
            if(swiftyJsonVar.isEmpty){
                onFinishListener(books,false)
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
                
                let FileIsFast = Array(swiftyJsonVar[x]["FileIsFast"].arrayObject as! [String])
                
                let audioIDS: AudioBookIDS = PositionIDSCorrectly(fileCount: FileCount, fileIDS: FileIDs, filePosition: FilePosition, fileIsFast: FileIsFast)
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
            onFinishListener(books, true)
        }
    }
}






