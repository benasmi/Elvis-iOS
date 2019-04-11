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
        /*newsItemName.text = String(utf8String: newsItem.name.cString(using: .utf8)!)*/
        newsItemName.text = newsItem.name
    }
    
    
}
