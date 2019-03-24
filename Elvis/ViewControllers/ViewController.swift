//
//  ViewController.swift
//  Elvis
//
//  Created by Benas on 21/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func login(_ sender: Any) {

    SVProgressHUD.show(withStatus: "Logging in...")
    SVProgressHUD.setDefaultMaskType(.black)
        var check: Bool = DatabaseUtils.Login(username: username.text as! String, password: password.text as! String, onFinishLoginListener: onFinishLoginListener)
        
    }
    
/*
 
*/
    
    func onFinishLoginListener(_ success: Bool){
        SVProgressHUD.dismiss()
        if(!success){
            Utils.alertMessage(message: "Neteisingas slaptažodis arba vartotojo vardas!", viewController: self)
            return
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainScreen") as! MainScreenController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    
}

