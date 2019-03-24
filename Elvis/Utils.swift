//
//  Utils.swift
//  Elvis
//
//  Created by Benas on 23/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit

class Utils{
    
    static func alertMessage(message:String, viewController: UIViewController){
        let alert = UIAlertController(title: "Klaida!", message: message, preferredStyle: UIAlertController.Style.alert);
        let okButton = UIAlertAction(title:"Bandyti dar kartą!", style: UIAlertAction.Style.default, handler:nil);
        alert.addAction(okButton);
        viewController.present(alert, animated: true, completion: nil);
    }
}
