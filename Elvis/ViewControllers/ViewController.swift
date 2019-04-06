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
    @IBOutlet weak var tv_username: UILabel!
    @IBOutlet weak var tv_password: UILabel!
    @IBOutlet weak var loginButton: DesignableButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        applyAccesibility()
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (preferences.object(forKey: "username") != nil) {
            moveToMainScreen()
        }
    }
    
    @IBAction func login(_ sender: Any) {
//        if(!Utils.connectedToNetwork()){
//            Utils.alertMessage(message: "Nėra interneto ryšio", viewController: self)
//            return
//        }
        
        guard let username = username.text else{
            SVProgressHUD.showInfo(withStatus: "Vartotojo vardo laukelis yra privalomas!")
            return
        }
        guard let password = password.text else{
            SVProgressHUD.showInfo(withStatus: "Slaptažodžio laukelis yra privalomas!")
            return
        }

        SVProgressHUD.show(withStatus: "Jungiamasi...")
        SVProgressHUD.setDefaultMaskType(.black)
        DatabaseUtils.Login(username: username, password: password, onFinishLoginListener: onFinishLoginListener)
        
    }
    
    func onFinishLoginListener(_ success: Bool, _ error: LoginError?){
        SVProgressHUD.dismiss()
        guard error == nil else{
            switch error! {
            case LoginError.NetworkError:
                Utils.alertMessage(message: "Nėra interneto ryšio", viewController: self)
            case LoginError.InvalidCredentials:
                Utils.alertMessage(message: "Neteisingas slaptažodis arba vartotojo vardas!", viewController: self)
            }
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

extension ViewController{
    /*
     difficultyLabel.isAccessibilityElement = true //1
     difficultyLabel.accessibilityTraits = UIAccessibilityTraitNone //2
     difficultyLabel.accessibilityLabel = "Difficulty Level" //3
     */
    
    func applyAccesibility(){
        //tv_username.font = UIFont.preferredFont(forTextStyle: .body)
        //tv_username.adjustsFontForContentSizeCategory = true
        //tv_username.isAccessibilityElement = false;
     
        
        //tv_password.font = UIFont.preferredFont(forTextStyle: .body)
        //tv_password.adjustsFontForContentSizeCategory = true
        //tv_password.isAccessibilityElement = false;
     
        username.font = UIFont.preferredFont(forTextStyle: .body)
        username.adjustsFontForContentSizeCategory = true
        username.isAccessibilityElement = true
        username.accessibilityTraits = UIAccessibilityTraits.none
        username.accessibilityLabel = "Login field"
        username.accessibilityValue = "Enter your username"
        
        password.isAccessibilityElement = true
        password.accessibilityTraits = UIAccessibilityTraits.none
        password.accessibilityLabel = "Password field"
        password.accessibilityValue = "Enter your password"
        password.font = UIFont.preferredFont(forTextStyle: .body)
        password.adjustsFontForContentSizeCategory = true
        
        loginButton.isAccessibilityElement = true
        loginButton.accessibilityLabel = "Click to login"
        loginButton.accessibilityTraits = .button
       
        registerButton.isAccessibilityElement = true
        registerButton.accessibilityLabel = "Click to register"
        registerButton.accessibilityTraits = .button
        
    }
    
}

