//
//  AudioBook.swift
//  Elvis
//
//  Created by Benas on 22/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AudioBook : Object{
    
    @objc dynamic var ID : String = ""
    @objc dynamic var Title: String = ""
    @objc dynamic var ReleaseDate: String = ""
    @objc dynamic var AuthorID: String = ""
    @objc dynamic var AuthorFirstName: String = ""
    @objc dynamic var AuthorLastName: String = ""
    @objc dynamic var SpeakerID: String = ""
    @objc dynamic var SpeakerFirstName: String = ""
    @objc dynamic var SpeakerLastName: String = ""
    @objc dynamic var PublicationNumber: Int = 0
    @objc dynamic var FileCount: Int = 0
    var FileNormalIDS = List<String>()
    var FileFastIDS = List<String>()
    
    
    convenience init(id: String, title: String, realeaseDate: String, authorID: String, authorFirstName: String, authorLastName: String, speakerId: String, speakerFirstName: String, speakerLastName: String, publicationNumber: Int, fileCount: Int, fileIdsNormal: List<String>, fileIdsFast: List<String>){
        self.init()
        
        ID = id
        Title = title
        ReleaseDate = realeaseDate
        AuthorID = authorID
        AuthorFirstName = authorFirstName
        AuthorLastName = authorLastName
        SpeakerID = speakerId
        SpeakerFirstName = speakerFirstName
        SpeakerLastName = speakerLastName
        PublicationNumber = publicationNumber
        FileCount = fileCount
        FileNormalIDS = fileIdsNormal
        FileFastIDS = fileIdsFast
        
    }
    
 
}
