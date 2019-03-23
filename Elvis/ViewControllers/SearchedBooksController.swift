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
        books = createBooks()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func createBooks() -> [AudioBook]{
        var tempBooks : [AudioBook] = []
        let book = AudioBook(bookTitle: "Mazasis princas", bookAuthor: "Martynas Dargis", bookAnouncer: "MD", bookYear: "2004", bookUrl: "123")
        let book1 = AudioBook(bookTitle: "Mazasis ", bookAuthor: "Martynas ", bookAnouncer: "M", bookYear: "200", bookUrl: "13")
        let book2 = AudioBook(bookTitle: "Mazasis ", bookAuthor: "Martynas ", bookAnouncer: "M", bookYear: "200", bookUrl: "13")
        let book3 = AudioBook(bookTitle: "Mazasis ", bookAuthor: "Martynas ", bookAnouncer: "M", bookYear: "200", bookUrl: "13")
        tempBooks.append(book)
        tempBooks.append(book1)
        tempBooks.append(book2)
        tempBooks.append(book3)
        return tempBooks
    }
}


extension SearchedBooksController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let audioBookCurrent : AudioBook = books[indexPath.row]
        let cell : AudioBookCell = tableView.dequeueReusableCell(withIdentifier: "AudioBookCell") as! AudioBookCell
        cell.setUpBook(audioBook: audioBookCurrent)
        
        return cell
    }
    
    
}
