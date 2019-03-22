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
    
    var bookTitle: String
    var bookAuthor: String
    var bookAnouncer: String
    var bookYear: String
    var bookURL: String

    init(bookTitle: String, bookAuthor: String, bookAnouncer: String, bookYear: String, bookUrl: String){
        self.bookTitle = bookTitle
        self.bookAuthor = bookAuthor
        self.bookAnouncer = bookAnouncer
        self.bookYear = bookYear
        self.bookURL = bookUrl
    
    }
}
