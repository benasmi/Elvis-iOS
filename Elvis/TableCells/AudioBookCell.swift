//
//  AudioBookCell.swift
//  Elvis
//
//  Created by Benas on 22/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit

class AudioBookCell: UITableViewCell {

    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookAnouncer: UILabel!
    @IBOutlet weak var years: UILabel!
    
    var book: AudioBook!
    var viewController: UIViewController!
    
    @IBAction func listen(_ sender: Any) {
      goToListenController()
    }
    
    @IBAction func listenFast(_ sender: Any) {
        
    }
    
    @IBAction func download(_ sender: Any) {
        
    }
    
    @IBAction func downloadFast(_ sender: Any) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(audioBook: AudioBook, viewController: UIViewController){
        book = audioBook
        self.viewController = viewController
        
        bookTitle.text = audioBook.Title
        bookAuthor.text = "Autorius: " + audioBook.AuthorFirstName + ", " + audioBook.AuthorLastName
        bookAnouncer.text = "Diktorius: " + audioBook.SpeakerFirstName  + ", " + audioBook.SpeakerLastName
        years.text = audioBook.ReleaseDate
    }
    
    func goToListenController(){
        //passing data and going to new view controller
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
        newViewController.book = book
        viewController.present(newViewController, animated: true, completion: nil)
    }
    
}
