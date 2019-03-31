//
//  MainScreenController.swift
//  Elvis
//
//  Created by Benas on 22/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//
import UIKit
import SVProgressHUD
import RealmSwift

class MainScreenController: UIViewController {
    
    let preferences = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func back(_ sender: Any) {
       confirmationMessage(message: "Ar tikrai norite atsijungti?", viewController: self)
    }
    
    @IBAction func newestBooks(_ sender: Any) {
        let disabilities = Utils.readFromSharedPreferences(key: "haveDisabilities")
        DatabaseUtils.NewestBooks(haveDisabilities: disabilities, onFinishListener: onFinishListener(_:))
        SVProgressHUD.show(withStatus: "Ieškoma naujausių knygų")
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    @IBAction func seeDownloads(_ sender: Any) {
        let books: [AudioBook] = Array(DatabaseUtils.getDownloadedBooks())
        //passing data and going to new view controller
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchedBooks") as! SearchedBooksController
        newViewController.books = books
        self.present(newViewController, animated: true, completion: nil)
        print(books.count)
    }
    
    func onFinishListener(_ books : [AudioBook]){
        SVProgressHUD.dismiss()
        if(books.isEmpty){
            Utils.alertMessage(message: "Nerasta naujų knygų", viewController: self)
            return
        }
        
        //passing data and going to new view controller
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchedBooks") as! SearchedBooksController
        newViewController.books = books
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    
    func confirmationMessage(message:String, viewController: UIViewController){
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Atsijungti!", message: message, preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Gerai", style: .default, handler: { (action) -> Void in
            viewController.dismiss(animated: true, completion: nil)
            Utils.deleteFromSharedPreferences(key: "username")
            Utils.deleteFromSharedPreferences(key: "password")
            Utils.deleteFromSharedPreferences(key: "sessionID")
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Atšaukti!", style: .cancel) { (action) -> Void in
            
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        viewController.present(dialogMessage, animated: true, completion: nil)
    }
    
}
