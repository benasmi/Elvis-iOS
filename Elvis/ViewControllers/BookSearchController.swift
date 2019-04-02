//
//  BookSearchController.swift
//  Elvis
//
//  Created by Benas on 22/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit
import SVProgressHUD

class BookSearchController: UIViewController {

    @IBOutlet weak var tv_anyWord: UITextField!
    @IBOutlet weak var tv_announcingPerson: UITextField!
    @IBOutlet weak var tv_name: UITextField!
    @IBOutlet weak var tv_title: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchBooks(_ sender: Any) {
        let haveDisabilities = Utils.readFromSharedPreferences(key: "haveDisabilities") as! String
        let anyWord = tv_anyWord.text as! String
        let announcingPerson = tv_announcingPerson.text as! String
        let name = tv_name.text as! String
        let title = tv_title.text as! String
        
        SVProgressHUD.show(withStatus: "Logging in...")
        SVProgressHUD.setDefaultMaskType(.black)
        
        DatabaseUtils.SearchBooks(haveDisabilities: haveDisabilities, title: title, name: name, announcingPerson: announcingPerson, anyWord: anyWord, onFinishListener: onFinishListener(_:))
   
    }
    
    func onFinishListener(_ books: [AudioBook]){
        SVProgressHUD.dismiss()
        if(books.isEmpty){
            Utils.alertMessage(message: "Tokių knygų nerasta!", viewController: self)
            return
        }
        
        //passing data and going to new view controller
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchedBooks") as! SearchedBooksController
        newViewController.books = books
        self.present(newViewController, animated: true, completion: nil)
    }
}
