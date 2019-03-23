//
//  DatabeUtils.swift
//  Elvis
//
//  Created by Benas on 23/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import Alamofire

let url = "http://elvis.labiblioteka.lt/app/login.php"
//let url = "https://www.google.lt/"

class DatabaseUtils{
    
 
    static func Login(username: String, password: String, onFinishLoginListener:(_ success: Bool) -> Void ) -> Bool{
        let json = [
            "UserName": username,
            "Password": password
        ]
        AF.request(url, method: .post, parameters: json, encoding: JSONEncoding.default, headers:nil).responseJSON{
            response in
                if let JSON = response.result.value as? NSDictionary{
                    print(JSON)
            }
        
        }
        return true
    }
    
    static func GetCookie(username: String, password: String) -> Bool{
        
        
        
        return true
    }
    
}




