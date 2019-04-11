//
//  NewsItem.swift
//  Elvis
//
//  Created by Benas on 09/04/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//
import Foundation

class NewsItem{
    var ID: String
    var name: String
    var description: NSAttributedString
    var isActive: String
    var activationDateFrom: String
    var activationDateTo: String
    
    init(ID: String, name: String, description: NSAttributedString, isActive: String, activationDateFrom: String, activationDateTo: String){
        self.ID = ID
        self.name = name
        self.description = description
        self.isActive = isActive
        self.activationDateTo = activationDateTo
        self.activationDateFrom = activationDateFrom
    }
}
