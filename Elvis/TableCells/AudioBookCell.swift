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


class AudioBookCell: UICell {
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookAnouncer: UILabel!
    @IBOutlet weak var years: UILabel!
    var delegate: SearchedBooksController!
    var indexPath: IndexPath!
    
    
    var sessionID: String!
    var book: AudioBook!
    var viewController: UIViewController!
    var bothExist : Bool = false //Two legends cannot co:exist muahahhahahhahhahahahhahhahahahhahahhahahahahahahhahahhaahhahahahahhahahahhahahahhahh
    
    
    @IBAction func listen(_ sender: Any) {
        goToListenController(fast: false)
    }
    
    @IBAction func listenFast(_ sender: Any) {
        goToListenController(fast: true)
    }
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBAction func download(_ sender: Any) {
        if(doesLocalVersionExist(IDsToCheck: book.FileNormalIDS)){
            //Erasing audio
            SVProgressHUD.show(withStatus: "Knyga ištrinama...")
            SVProgressHUD.setDefaultMaskType(.black)
            bothExist = self.bothExist(audioBook: self.book)
            DatabaseUtils.eraseBooks(audioBookIDs: book!.FileNormalIDS, listener: {
                self.downloadBtn.setTitle("SIŲSTIS", for: [])
                if(!self.bothExist){
                    DatabaseUtils.deleteBookInfo(audioBook: self.book)
                    self.delegate.removeBook(at: self.indexPath)
                }
                SVProgressHUD.dismiss()
            })
        }else{
            SVProgressHUD.show(withStatus: "Knyga siunčiama (0/" + String(book.FileNormalIDS.count) + ")")
            SVProgressHUD.setDefaultMaskType(.black)
            //Downloading audio
            
            DatabaseUtils.downloadBooks(sessionID: self.sessionID, audioBook: self.book, downloadFast: false, updateListener: { (chaptersDownloaded, totalChapters) in
                    
                SVProgressHUD.showProgress(Float(chaptersDownloaded)/Float(totalChapters), status: "Knyga siunčiama (" + String(chaptersDownloaded)  + "/" + String(totalChapters) + ")")
                
                if(chaptersDownloaded == totalChapters){
                    self.downloadBtn.setTitle("IŠTRINTI", for: [])
                    SVProgressHUD.dismiss()
                }

            })
            
        }
    }
    
    
    @IBOutlet weak var downloadFastBtn: UIButton!
    
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
            
            SVProgressHUD.show(withStatus: "Knyga siunčiama (0/" + String(book.FileFastIDS.count) + ")")
            SVProgressHUD.setDefaultMaskType(.black)
            //Downloading audio
            
            DatabaseUtils.downloadBooks(sessionID: self.sessionID, audioBook: self.book, downloadFast: true, updateListener: { (chaptersDownloaded, totalChapters) in
                
                SVProgressHUD.showProgress(Float(chaptersDownloaded)/Float(totalChapters), status: "Knyga siunčiama (" + String(chaptersDownloaded)  + "/" + String(totalChapters) + ")")
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
    
}
