//
//  ViewController.swift
//  Elvis
//
//  Created by Benas on 21/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func login(_ sender: Any) {
    
        var check : Bool = DatabaseUtils.Login(username: username.text as! String, password: password.text as! String, onFinishLoginListener: onFinishLoginListener)
        
    }
    
    
    
    
    func onFinishLoginListener(_ success: Bool){
        
    }
    
    
    
}

