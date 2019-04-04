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
    
    @IBOutlet weak var lblAnyword: UILabelPrimary!
    @IBOutlet weak var lblTitle: UILabelPrimary!
    @IBOutlet weak var lblAnouncingPerson: UILabelPrimary!
    @IBOutlet weak var lblDictor: UILabelPrimary!
    
    @IBOutlet weak var btnSeachBooks: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyAccesibility()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func changeContrast(_ sender: Any) {
        Theme.toggleTheme(viewController: self)
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

extension BookSearchController{
 
    func applyAccesibility(){
        lblAnyword.isAccessibilityElement = false;
        lblTitle.isAccessibilityElement = false;
        lblAnouncingPerson.isAccessibilityElement = false;
        lblDictor.isAccessibilityElement = false;
        
        tv_anyWord.font = UIFont.preferredFont(forTextStyle: .body)
        tv_anyWord.adjustsFontForContentSizeCategory = true
        tv_anyWord.isAccessibilityElement = true
        tv_anyWord.accessibilityTraits = UIAccessibilityTraits.none
        tv_anyWord.accessibilityLabel = "Anyword"
        tv_anyWord.accessibilityValue = "Search book by any word"
        
        tv_announcingPerson.font = UIFont.preferredFont(forTextStyle: .body)
        tv_announcingPerson.adjustsFontForContentSizeCategory = true
        tv_announcingPerson.isAccessibilityElement = true
        tv_announcingPerson.accessibilityTraits = UIAccessibilityTraits.none
        tv_announcingPerson.accessibilityLabel = "Anouncing person"
        tv_announcingPerson.accessibilityValue = "Search book by it's announcer"
        
        tv_name.font = UIFont.preferredFont(forTextStyle: .body)
        tv_name.adjustsFontForContentSizeCategory = true
        tv_name.isAccessibilityElement = true
        tv_name.accessibilityTraits = UIAccessibilityTraits.none
        tv_name.accessibilityLabel = "Book author"
        tv_name.accessibilityValue = "Search book by it's author"
        
        tv_title.font = UIFont.preferredFont(forTextStyle: .body)
        tv_title.adjustsFontForContentSizeCategory = true
        tv_title.isAccessibilityElement = true
        tv_title.accessibilityTraits = UIAccessibilityTraits.none
        tv_title.accessibilityLabel = "Title"
        tv_title.accessibilityValue = "Search book by it's title"
       
        
        btnSeachBooks.isAccessibilityElement = true
        btnSeachBooks.accessibilityLabel = "Click to search books"
        btnSeachBooks.accessibilityTraits = .button
        
    
        
    }
    
}
