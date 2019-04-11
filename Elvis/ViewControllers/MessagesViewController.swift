//
//  MessagesViewController.swift
//  Elvis
//
//  Created by Benas on 06/04/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit
import Foundation
import SVProgressHUD
class MessagesViewController: UIViewController{
    
    @IBOutlet weak var messageToAdministrationBtn: UIButton!
    @IBOutlet weak var messagesReceivedBtn: UIButton!
    @IBOutlet weak var newsBtn: UIButton!
    
    @IBAction func messagesReceived(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "Siunčiamos gautos žinutės")
        SVProgressHUD.setDefaultMaskType(.black)
        
        DatabaseUtils.getMessages { (success, messages) in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MessagesReceived") as! MessagesReceivedViewController
            
            SVProgressHUD.dismiss()
            guard success else{
                SVProgressHUD.showInfo(withStatus: "Nepavyko parsiųsti žinučių")
                return
            }
            
            newViewController.messages = messages
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func news(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Siunčiamos naujienos")
        SVProgressHUD.setDefaultMaskType(.black)
        DatabaseUtils.fetchNews { (success, newsItems) in
            
            SVProgressHUD.dismiss()
            
            guard success else{
                SVProgressHUD.showInfo(withStatus: "Nepavyko parsiųsti naujienų")
                return
            }
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
            newViewController.newsItems = newsItems
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func messageToAdministration(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MessageToAdministrators") as! MessageToAdministratorsViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
}
