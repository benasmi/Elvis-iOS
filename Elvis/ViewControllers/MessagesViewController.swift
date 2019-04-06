//
//  MessagesViewController.swift
//  Elvis
//
//  Created by Benas on 06/04/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController{
    
    @IBOutlet weak var messageToAdministrationBtn: UIButton!
    @IBOutlet weak var messagesReceivedBtn: UIButton!
    @IBOutlet weak var newsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func messageToAdministration(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MessageToAdministrators") as! MessageToAdministratorsViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
}
