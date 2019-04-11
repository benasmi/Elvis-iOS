//
//  Message.swift
//  Elvis
//
//  Created by Benas on 09/04/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation

class Message{
    
    var content: String
    var subject: String
    var parentMessageID: Int?
    var date: Date
    var LinkedPublicationID: Int?
    var messageID: String
    
    init(content: String, subject: String, parentMessageID: Int?, date: Date, LinkedPublicationID: Int?, messageID: String){
        self.content = content
        self.subject = subject
        self.parentMessageID = parentMessageID
        self.date = date
        self.LinkedPublicationID = LinkedPublicationID
        self.messageID = messageID
    }
}
