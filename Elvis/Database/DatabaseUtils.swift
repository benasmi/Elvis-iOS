//
//  DatabeUtils.swift
//  Elvis
//
//  Created by Benas on 23/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import Alamofire

//let url = "http://elvis.labiblioteka.lt/app/login.php"

class DatabaseUtils{
    
 
    static func Login(username: String, password: String, onFinishLoginListener:@escaping (_ success: Bool) -> Void ) -> Bool{
 
        let url = "http://elvis.labiblioteka.lt/app/login.php"
        let json : Parameters = [
            "UserName": username,
            "Password": password
        ]
    
        AF.request(url, method: .post, parameters: json, encoding: URLEncoding.httpBody, headers:nil).responseJSON{
            response in
                if let JSON = response.result.value as? NSDictionary{
                    print(JSON)
                    GetCookie(username: username, password: password, onFinishLoginListener: onFinishLoginListener)
                }else{
                    onFinishLoginListener(false)
            }
        }
        return true
    }
    
    static func GetCookie(username: String, password: String, onFinishLoginListener:@escaping (_ success: Bool) -> Void){
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
                    let preferences = UserDefaults.standard
                    preferences.set(username, forKey: "usernameLogin");
                    preferences.set(password, forKey: "passwordLogin");
                    preferences.set(cookie.value, forKey: "sessionID")
                    preferences.synchronize();
                    onFinishLoginListener(true)
                    return
                }
            }
            
        }
    }

}




