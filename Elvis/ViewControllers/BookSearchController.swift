//
//  BookSearchController.swift
//  Elvis
//
//  Created by Benas on 22/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit
import SVProgressHUD

class BookSearchController: BaseViewController {

    @IBOutlet weak var tv_anyWord: UITextField!
    @IBOutlet weak var tv_announcingPerson: UITextField!
    @IBOutlet weak var tv_name: UITextField!
    @IBOutlet weak var tv_title: UITextField!
    
    @IBOutlet weak var lblAnyword: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAnouncingPerson: UILabel!
    @IBOutlet weak var lblDictor: UILabel!
    
    @IBOutlet weak var btnSeachBooks: UIButton!
    
    override func disableDarkMode(){
        tv_anyWord.textColor = UIColor.black
        tv_announcingPerson.textColor = UIColor.black
        tv_name.textColor = UIColor.black
        tv_title.textColor = UIColor.black
        
        lblAnyword.textColor = UIColor.black
        lblTitle.textColor = UIColor.black
        lblAnouncingPerson.textColor = UIColor.black
        lblDictor.textColor = UIColor.black
        
        self.view.backgroundColor = UIColor.white
    }
    override func enableDarkMode(){
        tv_anyWord.textColor = UIColor.white
        tv_announcingPerson.textColor = UIColor.white
        tv_name.textColor = UIColor.white
        tv_title.textColor = UIColor.white
        
        lblAnyword.textColor = UIColor.white
        lblTitle.textColor = UIColor.white
        lblAnouncingPerson.textColor = UIColor.white
        lblDictor.textColor = UIColor.white

        self.view.backgroundColor = UIColor.black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyAccesibility()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func changeContrast(_ sender: Any) {
        toggleMode()
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchBooks(_ sender: Any) {
        let haveDisabilities = Utils.readFromSharedPreferences(key: "haveDisabilities") as! String
        let anyWord = tv_anyWord.text!
        let announcingPerson = tv_announcingPerson.text!
        let name = tv_name.text!
        let title = tv_title.text!
        
        SVProgressHUD.show(withStatus: "Ieškoma knygų...")
        SVProgressHUD.setDefaultMaskType(.black)
        
        DatabaseUtils.SearchBooks(haveDisabilities: haveDisabilities, title: title, name: name, announcingPerson: announcingPerson, anyWord: anyWord, onFinishListener: onFinishListener(_:))
   
    }
    
    func onFinishListener(_ books: [AudioBook]){
        SVProgressHUD.dismiss()
        if(books.isEmpty){
            Utils.alertMessage(message: "Tokių knygų nerasta!", title: "Klaida", buttonTitle: "Bandyti dar kartą!",viewController: self)
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
