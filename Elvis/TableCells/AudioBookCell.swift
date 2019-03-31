//
//  AudioBookCell.swift
//  Elvis
//
//  Created by Benas on 22/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit
import SVProgressHUD


class AudioBookCell: UITableViewCell {
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookAnouncer: UILabel!
    @IBOutlet weak var years: UILabel!
    
    var sessionID: String!
    var book: AudioBook!
    var viewController: UIViewController!
    
    
    @IBAction func listen(_ sender: Any) {
        goToListenController(fast: false)
    }
    
    @IBAction func listenFast(_ sender: Any) {
        goToListenController(fast: true)
    }
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBAction func download(_ sender: Any) {
        if(doesLocalVersionExist(IDsToCheck: book.AudioIDS!.FileNormal)){
            //Erasing audio
            SVProgressHUD.show(withStatus: "Knyga istrinama...")
            SVProgressHUD.setDefaultMaskType(.black)
            DatabaseUtils.eraseBooks(audioBookIDs: book.AudioIDS!.FileNormal, listener: {
                self.downloadBtn.setTitle("Siusti", for: [])
                SVProgressHUD.dismiss()
            })
        }else{
            SVProgressHUD.show(withStatus: "Knyga siunciama...")
            SVProgressHUD.setDefaultMaskType(.black)
            //Downloading audio
            DatabaseUtils.downloadBooks(sessionID: sessionID, audioBook: book, downloadFast: false, listener: {
                self.downloadBtn.setTitle("Istrinti", for: [])
                SVProgressHUD.dismiss()
            })
        }
    }
    
    
    @IBOutlet weak var downloadFastBtn: UIButton!
    
    @IBAction func downloadFast(_ sender: Any) {
        if(doesLocalVersionExist(IDsToCheck: book.AudioIDS!.FileFast)){
            //Erasing audio
            SVProgressHUD.show(withStatus: "Knyga istrinama...")
            SVProgressHUD.setDefaultMaskType(.black)
            DatabaseUtils.eraseBooks(audioBookIDs: book.AudioIDS!.FileFast, listener: {
                self.downloadFastBtn.setTitle("Siusti", for: [])
                DatabaseUtils.deleteBookInfo(audioBook: self.book)
                SVProgressHUD.dismiss()
            })
        }else{
            SVProgressHUD.show(withStatus: "Knyga siunciama...")
            SVProgressHUD.setDefaultMaskType(.black)
            //Downloading audio
            DatabaseUtils.downloadBooks(sessionID: sessionID, audioBook: book, downloadFast: true, listener: {
                self.downloadFastBtn.setTitle("Istrinti", for: [])
                DatabaseUtils.deleteBookInfo(audioBook: self.book)
                SVProgressHUD.dismiss()
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
    
    func setUpCell(audioBook: AudioBook, viewController: UIViewController, session: String){
        book = audioBook
        sessionID = session
        self.viewController = viewController
        
        bookTitle.text = audioBook.Title
        bookAuthor.text = "Autorius: " + audioBook.AuthorFirstName + ", " + audioBook.AuthorLastName
        bookAnouncer.text = "Diktorius: " + audioBook.SpeakerFirstName  + ", " + audioBook.SpeakerLastName
        years.text = audioBook.ReleaseDate
        
        self.downloadBtn.setTitle(doesLocalVersionExist(IDsToCheck: book.AudioIDS!.FileNormal) ? "Istrinti" : "Siustis", for: [])
        self.downloadFastBtn.setTitle(doesLocalVersionExist(IDsToCheck: book.AudioIDS!.FileFast) ? "Istrinti" : "Siustis", for: [])
    }
    
    //This only checks if all parts of the audiobook ar present in the file system. Such a method is not foolproof
    func doesLocalVersionExist(IDsToCheck: [String]) -> Bool{
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
        newViewController.isLocal = doesLocalVersionExist(IDsToCheck: fast ? book.AudioIDS!.FileFast : book.AudioIDS!.FileNormal)
        viewController.present(newViewController, animated: true, completion: nil)
    }
    
}
