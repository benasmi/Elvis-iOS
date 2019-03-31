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
}


extension SearchedBooksController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let audioBookCurrent : AudioBook = books[indexPath.row]
        let cell : AudioBookCell = tableView.dequeueReusableCell(withIdentifier: "AudioBookCell") as! AudioBookCell
        cell.setUpCell(audioBook: audioBookCurrent, viewController: self, session: Utils.readFromSharedPreferences(key: "sessionID"))
        return cell
    }
}
