//
//  AudioBook.swift
//  Elvis
//
//  Created by Benas on 22/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit

class AudioBook{
    
    var ID : String
    var Title: String
    var ReleaseDate: String
    var AuthorID: String
    var AuthorFirstName: String
    var AuthorLastName: String
    var SpeakerID: String
    var SpeakerFirstName: String
    var SpeakerLastName: String
    var PublicationNumber: Int
    var FileCount: Int
    var FileIDs: [String]
    var FileIsFast: [String]
    var FilePosition: [String]
    
    init(id: String, title: String, realeaseDate: String, authorID: String, authorFirstName: String, authorLastName: String, speakerId: String, speakerFirstName: String, speakerLastName: String, publicationNumber: Int, fileCount: Int, fileIDs: [String], fileIsFast : [String], filePosition : [String]){
        
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
        FileIDs = fileIDs
        FileIsFast = fileIsFast
        FilePosition = filePosition
    }
    
}
