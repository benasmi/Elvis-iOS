//
//  MessageCell.swift
//  Elvis
//
//  Created by Benas on 07/04/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell{
    
    @IBOutlet weak var messageTopic: UILabel!
    @IBOutlet weak var messageBody: UITextView!
    
    
    var message: Message!
    
    func setUpCell(message: Message){
        self.message = message
        
        self.selectionStyle = .none

        messageBody.text = self.message.content
        messageTopic.text = "Tema: " + self.message.subject
    }
    
    func enableNightMode(){
        messageTopic.textColor = UIColor.white
        messageBody.textColor = UIColor.white
      
        
        self.contentView.backgroundColor = UIColor.black
        
    }
    func disableNightMode(){
        
        messageTopic.textColor = UIColor.black
        messageBody.textColor = UIColor.black
        
        self.contentView.backgroundColor = UIColor.white
        
    }
    
}
