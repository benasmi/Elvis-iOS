//
//  NewsViewController.swift
//  Elvis
//
//  Created by Benas on 10/04/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var newsItems: [NewsItem]! = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : NewsItemCell = tableView.dequeueReusableCell(withIdentifier: "newsItemCell") as! NewsItemCell
        cell.setUpCell(newsItem: newsItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewsItemReader") as! NewsItemViewController
        newViewController.newsItem = newsItems[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
