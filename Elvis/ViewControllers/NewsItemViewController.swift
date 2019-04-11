//
//  NewsItemViewController.swift
//  Elvis
//
//  Created by Benas on 10/04/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit

class NewsItemViewController: UIViewController{
    
    @IBOutlet weak var newsItemView: UITextView!
    var newsItem: NewsItem!
    @IBOutlet weak var newsItemContent: UITextView!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        newsItemView.attributedText = newsItem.description
    }
    
}
