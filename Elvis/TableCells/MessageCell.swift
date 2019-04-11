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
    
}
