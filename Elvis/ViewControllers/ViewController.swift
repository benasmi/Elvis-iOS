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
    
    let preferences = UserDefaults.standard
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (preferences.object(forKey: "username") != nil) {
            moveToMainScreen()
        }
    }
    
    @IBAction func login(_ sender: Any) {
        if(!Utils.connectedToNetwork()){
            Utils.alertMessage(message: "Nėra interneto ryšio", viewController: self)
            return
        }

        SVProgressHUD.show(withStatus: "Jungiamasi...")
        SVProgressHUD.setDefaultMaskType(.black)
        DatabaseUtils.Login(username: username.text as! String, password: password.text as! String, onFinishLoginListener: onFinishLoginListener)
        
    }
    
    func onFinishLoginListener(_ success: Bool){
        SVProgressHUD.dismiss()
        if(!success){
            Utils.alertMessage(message: "Neteisingas slaptažodis arba vartotojo vardas!", viewController: self)
            return
        }
       moveToMainScreen()
    }
    
    func moveToMainScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainScreen") as! MainScreenController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
}

