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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpBook(audioBook : AudioBook){
        bookTitle.text = audioBook.Title
        bookAuthor.text = "Autorius: " + audioBook.AuthorFirstName + ", " + audioBook.AuthorLastName
        bookAnouncer.text = "Diktorius: " + audioBook.SpeakerFirstName  + ", " + audioBook.SpeakerLastName
        years.text = audioBook.ReleaseDate
    }
    
}
