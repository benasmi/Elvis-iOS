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
class MessagesViewController: BaseViewController{
    
    @IBOutlet weak var messageToAdministrationBtn: UIButton!
    @IBOutlet weak var messagesReceivedBtn: UIButton!
    @IBOutlet weak var newsBtn: UIButton!
    
    @IBAction func changeTheme(_ sender: Any) {
        toggleMode()
    }
    @IBAction func messagesReceived(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "Siunčiamos gautos žinutės")
        SVProgressHUD.setDefaultMaskType(.black)
        
        DatabaseUtils.getMessages { (success, messages) in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MessagesReceived") as! MessagesReceivedViewController
            
            SVProgressHUD.dismiss()
            guard success else{
                Utils.alertMessage(message: "Nepavyko parsiųsti žinučių!", title: "Klaida!", buttonTitle: "Bandyti dar kartą", viewController: self)
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
                 Utils.alertMessage(message: "Nepavyko parsiųsti naujienų!", title: "Klaida!", buttonTitle: "Bandyti dar kartą", viewController: self)
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
        applyAccesibility()
        super.viewDidLoad()
    }
    
    @IBAction func messageToAdministration(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MessageToAdministrators") as! MessageToAdministratorsViewController
        self.present(newViewController, animated: true, completion: nil)
    }

    
    override func enableDarkMode(){
        messageToAdministrationBtn.backgroundColor = UIColor.clear
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
        ]
        let attributedQuote = NSAttributedString(string: messageToAdministrationBtn.titleLabel!.text!, attributes: attributes)
        messageToAdministrationBtn.setAttributedTitle(attributedQuote, for: .normal)
        
        
        messagesReceivedBtn.backgroundColor = UIColor.clear
        messagesReceivedBtn.setTitleColor(.white, for: .normal)
        
        newsBtn.backgroundColor = UIColor.clear
        newsBtn.setTitleColor(.white, for: .normal)
        
        self.view.backgroundColor = UIColor.black
        
    }
    override func disableDarkMode(){
        messageToAdministrationBtn.backgroundColor = UIColor.clear
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        let attributedQuote = NSAttributedString(string: messageToAdministrationBtn.titleLabel!.text!, attributes: attributes)
        messageToAdministrationBtn.setAttributedTitle(attributedQuote, for: .normal)
        
        messagesReceivedBtn.backgroundColor = UIColor.clear
        messagesReceivedBtn.setTitleColor(.black, for: .normal)
        
        newsBtn.backgroundColor = UIColor.clear
        newsBtn.setTitleColor(.black, for: .normal)
        
        self.view.backgroundColor = UIColor.white
    }
    
}

extension MessagesViewController{
    func applyAccesibility(){
    
     
        messageToAdministrationBtn.isAccessibilityElement = true
        messageToAdministrationBtn.accessibilityTraits = UIAccessibilityTraits.button
        messageToAdministrationBtn.accessibilityLabel = "Spauskite norėdami rašyti žinutę administraijai"
        
        messagesReceivedBtn.isAccessibilityElement = true
        messagesReceivedBtn.accessibilityTraits = UIAccessibilityTraits.button
        messagesReceivedBtn.accessibilityLabel = "Spauskite norėdami peržiūrėti žinutes"
     
        newsBtn.isAccessibilityElement = true
        newsBtn.accessibilityTraits = UIAccessibilityTraits.button
        newsBtn.accessibilityLabel = "Spauskite norėdami pamatyti naujienas"
        
    }
}

