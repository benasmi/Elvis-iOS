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

class ViewController: BaseViewController {
    
    let preferences = UserDefaults.standard
    @IBOutlet weak var backgroundView: UIView!
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
    
    override func enableDarkMode(){
        username.backgroundColor = UIColor.clear
        username.textColor = UIColor.white
        
        password.backgroundColor = UIColor.clear
        password.textColor = UIColor.white
        
        tv_username.textColor = UIColor.white
        tv_password.textColor = UIColor.white
        
        self.view.backgroundColor = UIColor.black
        self.backgroundView.backgroundColor = UIColor.black
    }
    
    override func disableDarkMode(){
        username.backgroundColor = UIColor.clear
        username.textColor = UIColor.black
        
        password.backgroundColor = UIColor.clear
        password.textColor = UIColor.black
        
        tv_username.textColor = UIColor.black
        tv_password.textColor = UIColor.black
        
        self.backgroundView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if (preferences.object(forKey: "username") != nil) {
            moveToMainScreen()
        }
    }
    
    @IBAction func login(_ sender: Any) {
        
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
                Utils.alertMessage(message: "Nėra interneto ryšio", title: "Klaida", buttonTitle: "Bandyti dar kartą!", viewController: self)
            case LoginError.InvalidCredentials:
                Utils.alertMessage(message: "Neteisingas slaptažodis arba vartotojo vardas!", title: "Klaida", buttonTitle: "Bandyti dar kartą!", viewController: self)
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

    func applyAccesibility(){
      
        tv_username.isAccessibilityElement = false
        tv_password.isAccessibilityElement = false
        
        username.font = UIFont.preferredFont(forTextStyle: .body)
        username.adjustsFontForContentSizeCategory = true
        username.isAccessibilityElement = true
        //username.accessibilityTraits = UIAccessibilityTraits.none
        username.accessibilityLabel = "Prisijungimo vardas"
        username.accessibilityValue = "Įveskite prisijungimo vardas"
        
        password.isAccessibilityElement = true
        password.accessibilityTraits = UIAccessibilityTraits.none
        password.accessibilityLabel = "Slaptažodžis"
        password.accessibilityValue = "Įveskite slaptažodis"
        password.font = UIFont.preferredFont(forTextStyle: .body)
        password.adjustsFontForContentSizeCategory = true
        
        loginButton.isAccessibilityElement = true
        loginButton.accessibilityLabel = "Prisijungti"
        loginButton.accessibilityTraits = .button
       
        registerButton.isAccessibilityElement = true
        registerButton.accessibilityLabel = "Registracija"
        registerButton.accessibilityTraits = .button
        
    }
    
}

