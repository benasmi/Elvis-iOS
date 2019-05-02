//
//  NewsItemViewController.swift
//  Elvis
//
//  Created by Benas on 10/04/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit

class NewsItemViewController: BaseViewController{
    
    @IBAction func changeTheme(_ sender: Any) {
        toggleMode()
    }
    
    @IBOutlet weak var newsItemView: UITextView!
    var newsItem: NewsItem!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        newsItemView.attributedText = newsItem.description
    }
    
    override func disableDarkMode(){
        newsItemView.textColor = UIColor.black
        
      
        
        self.view.backgroundColor = UIColor.white
    }
    override func enableDarkMode(){
        newsItemView.textColor = UIColor.white

        
    
        self.view.backgroundColor = UIColor.black
    }
    
}
