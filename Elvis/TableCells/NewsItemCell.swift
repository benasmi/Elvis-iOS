//
//  NewsItemCell.swift
//  Elvis
//
//  Created by Benas on 10/04/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit

class NewsItemCell: UITableViewCell{
    
    var newsItem: NewsItem!
    
    @IBOutlet weak var newsItemName: UITextView!
    
    func setUpCell(newsItem : NewsItem){
        self.newsItem = newsItem
        applyAccesibility(newsItem: newsItem)
        /*newsItemName.text = String(utf8String: newsItem.name.cString(using: .utf8)!)*/
        newsItemName.text = newsItem.name
    }
    
    func enableNightMode(){
        newsItemName.textColor = UIColor.white
        
        
        self.contentView.backgroundColor = UIColor.black
        
    }
    func disableNightMode(){
        
        newsItemName.textColor = UIColor.black
        self.contentView.backgroundColor = UIColor.white
        
    }
    
    
}

extension NewsItemCell{
    
    func applyAccesibility(newsItem: NewsItem){
        
        newsItemName.isAccessibilityElement = true
        newsItemName.accessibilityLabel = newsItem.name
        newsItemName.accessibilityValue = "Click to hear more!"
        newsItemName.accessibilityTraits = .staticText
        
    }
    
}
