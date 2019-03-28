//
//  AudioBookIDS.swift
//  Elvis
//
//  Created by Benas on 28/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation

class AudioBookIDS{
    var FileNormal: [String]
    var FileFast: [String]
    
    init(fileIDs: [String], fileIsFast : [String]){
        FileNormal = fileIDs
        FileFast = fileIsFast
    }
}
