//
//  Utils.swift
//  Elvis
//
//  Created by Benas on 23/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Utils{
    
    static let DateFormat = "yyyy-MM-dd HH:mm:ss"
    
    static func connectedToNetwork() -> Bool{
        return (NetworkReachabilityManager()?.isReachable)!
    }
    
    
    
    static func alertMessage(message:String, viewController: UIViewController){
        let alert = UIAlertController(title: "Klaida!", message: message, preferredStyle: UIAlertController.Style.alert);
        let okButton = UIAlertAction(title:"Bandyti dar kartą!", style: UIAlertAction.Style.default, handler:nil);
        alert.addAction(okButton);
        viewController.present(alert, animated: true, completion: nil);
    }
    
    static func writeToSharedPreferences(key: String, value: Any){
        let preferences = UserDefaults.standard
        preferences.set(value, forKey: key);
        preferences.synchronize()
    }
    
    static func readFromSharedPreferences(key: String) -> Any{
        return UserDefaults.standard.object(forKey: key)
    }
    
    static func getDateFromString(date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Utils.DateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        return dateFormatter.date(from:date)!
    }
    
    static func getAttributedString(string: String) -> NSAttributedString?{
        let data = string.data(using: String.Encoding.unicode)!
        let attrStr = try? NSAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        return attrStr
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    static func deleteFromSharedPreferences(key: String){
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}
