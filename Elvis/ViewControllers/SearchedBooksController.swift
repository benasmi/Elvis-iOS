//
//  SearchedBooksController.swift
//  Elvis
//
//  Created by Benas on 22/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit


class SearchedBooksController: UIViewController {

    var books : [AudioBook] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
}


extension SearchedBooksController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let audioBookCurrent : AudioBook = books[indexPath.row]
        let cell : AudioBookCell = tableView.dequeueReusableCell(withIdentifier: "AudioBookCell") as! AudioBookCell
        cell.setUpCell(audioBook: audioBookCurrent, viewController: self, session: Utils.readFromSharedPreferences(key: "sessionID") as! String)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(books.count == 0){
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Knygu nerasta"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }else{
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        return 1
    }
    
    func removeBook(at: IndexPath){
        print("index: " + String(at.row))
        self.books.remove(at: at.row)
        self.tableView.deleteRows(at: [at], with: .automatic)
        self.tableView.reloadData()
    }
}
