//
//  AudioBookCell.swift
//  Elvis
//
//  Created by Benas on 22/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import RealmSwift


class AudioBookCell: UITableViewCell {
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookAnouncer: UILabel!
    @IBOutlet weak var years: UILabel!
    
    @IBOutlet weak var listenBtn: UIButton!
    @IBOutlet weak var listenFastBtn: UIButton!
    
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var downloadFastBtn: UIButton!
    
    var delegate: SearchedBooksController!
    var indexPath: IndexPath!
    
    
    var sessionID: String!
    var book: AudioBook!
    var viewController: UIViewController!
    var bothExist : Bool = false
 
    
    
    @IBAction func listen(_ sender: Any) {
        goToListenController(fast: false)
        DatabaseUtils.addToRecentsList(book: book)
    }
    
    @IBAction func listenFast(_ sender: Any) {
        goToListenController(fast: true)
        DatabaseUtils.addToRecentsList(book: book)
    }
   
    @IBAction func download(_ sender: Any) {
        
        //Checking if book already exists -> Erasing
        if(doesLocalVersionExist(IDsToCheck: book.FileNormalIDS)){
            //Erasing audio
            SVProgressHUD.show(withStatus: "Knyga ištrinama...")
            SVProgressHUD.setDefaultMaskType(.black)
            
            //Check if fast and normal books are downloaded
            bothExist = self.bothExist(audioBook: self.book)
            
            DatabaseUtils.eraseBooks(audioBookIDs: book!.FileNormalIDS, listener: {
                self.downloadBtn.setTitle("SIŲSTIS", for: [])
                if(!self.bothExist){
                    //Checking if only fast or normal book was downloaded. From this we can decide if we want to remove from tableView
                    DatabaseUtils.deleteBookInfo(audioBook: self.book)
                    self.delegate.removeBook(at: self.indexPath)
                }
                SVProgressHUD.dismiss()
            })
            
            //Downloading book
        }else{
            SVProgressHUD.show(withStatus: "Siunčiamas skirsnis (0/" + String(book.FileNormalIDS.count) + ")")
            SVProgressHUD.setDefaultMaskType(.black)
            //Downloading audio
            
            DatabaseUtils.downloadBooks(sessionID: self.sessionID, audioBook: self.book, downloadFast: false, updateListener: { (chaptersDownloaded, totalChapters, success) in
                
                
                guard success else{
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showInfo(withStatus: "An unexpected error has occured")
                    return
                }
                
                SVProgressHUD.showProgress(Float(chaptersDownloaded)/Float(totalChapters), status: "Siunčiamas skirsnis (" + String(chaptersDownloaded)  + "/" + String(totalChapters) + ")")
                
                //Downloaded all books
                if(chaptersDownloaded == totalChapters){
                    self.downloadBtn.setTitle("IŠTRINTI", for: [])
                    SVProgressHUD.dismiss()
                }

            })
            
        }
    }
    
    
    @IBAction func downloadFast(_ sender: Any) {
        if(doesLocalVersionExist(IDsToCheck: book.FileFastIDS)){
            //Erasing audio
            SVProgressHUD.show(withStatus: "Knyga ištrinama...")
            SVProgressHUD.setDefaultMaskType(.black)
            bothExist = self.bothExist(audioBook: self.book)
            DatabaseUtils.eraseBooks(audioBookIDs: book.FileFastIDS, listener: {
                self.downloadFastBtn.setTitle("SIŲSTIS PAGREITINTĄ", for: [])
                if(!self.bothExist){
                    DatabaseUtils.deleteBookInfo(audioBook: self.book)
                    self.delegate.removeBook(at: self.indexPath)
                }
                SVProgressHUD.dismiss()
            })
        }else{
            
            SVProgressHUD.show(withStatus: "Siunčiamas skirsnis (0/" + String(book.FileFastIDS.count) + ")")
            SVProgressHUD.setDefaultMaskType(.black)
            //Downloading audio
            
            DatabaseUtils.downloadBooks(sessionID: self.sessionID, audioBook: self.book, downloadFast: true, updateListener: { (chaptersDownloaded, totalChapters, success) in
                
                guard success else{
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showInfo(withStatus: "An unexpected error has occured")
                    return
                }
                
                SVProgressHUD.showProgress(Float(chaptersDownloaded)/Float(totalChapters), status: "Siunčiamas skirsnis (" + String(chaptersDownloaded)  + "/" + String(totalChapters) + ")")
                if(chaptersDownloaded == totalChapters){
                    self.downloadFastBtn.setTitle("IŠTRINTI PAGREITINTĄ", for: [])
                    SVProgressHUD.dismiss()
                }
            })
            
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //Checks if fast and normal audio files exist
    func bothExist(audioBook: AudioBook) -> Bool{
        if(doesLocalVersionExist(IDsToCheck: audioBook.FileNormalIDS) && doesLocalVersionExist(IDsToCheck: audioBook.FileFastIDS) ){
            return true
        }
        return false
    }
    
    func setUpCell(audioBook: AudioBook, viewController: UIViewController, session: String){
        book = audioBook
        sessionID = session
        self.viewController = viewController
        
        bookTitle.text = audioBook.Title
        bookAuthor.text = "Autorius: " + audioBook.AuthorFirstName + ", " + audioBook.AuthorLastName
        bookAnouncer.text = "Diktorius: " + audioBook.SpeakerFirstName  + ", " + audioBook.SpeakerLastName
        years.text = audioBook.ReleaseDate
        
        self.downloadBtn.setTitle(doesLocalVersionExist(IDsToCheck: book.FileNormalIDS) ? "IŠTRINTI" : "SIŲSTIS", for: [])
        self.downloadFastBtn.setTitle(doesLocalVersionExist(IDsToCheck: book.FileFastIDS) ? "IŠTRINTI PAGREITINTĄ" : "SIŲSTIS PAGREITINTĄ", for: [])
    }
    
    //Checks if audio files are already in the phone directory
    func doesLocalVersionExist(IDsToCheck: List<String>) -> Bool{
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        for id in IDsToCheck{
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(id + ".mp3")
            if(!FileManager.default.fileExists(atPath: destinationUrl.path)){
                return false;
            }
        }
        return true;
    }
    
    
    func goToListenController(fast: Bool){
        //passing data and going to new view controller
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
        newViewController.book = book
        newViewController.isFast = fast;
        newViewController.isLocal = doesLocalVersionExist(IDsToCheck: fast ? book.FileFastIDS : book.FileNormalIDS)
        viewController.present(newViewController, animated: true, completion: nil)
    }
    
    func enableNightMode(){
        bookTitle.textColor = UIColor.white
        bookAuthor.textColor = UIColor.white
        bookAnouncer.textColor = UIColor.white
        
        listenBtn.setTitleColor(UIColor.black, for: .normal)
        listenFastBtn.setTitleColor(UIColor.black, for: .normal)
        
        downloadBtn.backgroundColor = UIColor.white
        downloadFastBtn.backgroundColor = UIColor.white
        
        downloadBtn.setTitleColor(UIColor.black, for: .normal)
        downloadFastBtn.setTitleColor(UIColor.black, for: .normal)
        
        
        self.contentView.backgroundColor = UIColor.black
        
    }
    func disableNightMode(){
        
        bookTitle.textColor = UIColor.black
        bookAuthor.textColor = UIColor.black
        bookAnouncer.textColor = UIColor.black
        
        listenBtn.setTitleColor(UIColor.white, for: .normal)
        listenFastBtn.setTitleColor(UIColor.white, for: .normal)
        
        downloadBtn.backgroundColor = UIColor.black
        downloadFastBtn.backgroundColor = UIColor.black
        
        downloadBtn.setTitleColor(UIColor.white, for: .normal)
        downloadFastBtn.setTitleColor(UIColor.white, for: .normal)
        
        
        self.contentView.backgroundColor = UIColor.white
        
    }
}


