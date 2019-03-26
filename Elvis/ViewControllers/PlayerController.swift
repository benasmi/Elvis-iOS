//
//  PlayerController.swift
//  Elvis
//
//  Created by Benas on 26/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit
import SelectionList

class PlayerController: UIViewController {

    var book: AudioBook!
    var chapters : [String]!
    
    @IBOutlet weak var tv_bookTitle: UILabel!
    @IBOutlet weak var tv_time: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chapters = createChapters(book: book)
        print(chapters)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }


    @IBAction func changeChapter(_ sender: Any) {
        configureChapterSelector()
    }
    @IBAction func play(_ sender: Any) {
        
    }
    @IBAction func fastForward(_ sender: Any) {
        
    }
    
    @IBAction func skipForward(_ sender: Any) {
        
    }
    
    @IBAction func fastBackwards(_ sender: Any) {
        
    }
    
    @IBAction func skipPrevious(_ sender: Any) {
        
    }
    
    @IBAction func back(_ sender: Any) {
        
    }
    
    
    func createChapters(book: AudioBook) -> [String]{
        var chapterArray : [String] = []
        var x: Int = 0;
        while x < book.FileCount{
            let chapter: String = "Skirsnis: " + String(x+1)
            chapterArray.append(chapter)
            x = x + 1
        }
        return chapterArray
    }
    
    func configureChapterSelector(){
        print("Nu patenk, bet neveik. Hmmm")
        let selectionList = SelectionList()
        selectionList.items = chapters
        selectionList.addTarget(self, action: #selector(onSelectionChanged), for: .valueChanged)
        selectionList.allowsMultipleSelection = false
        selectionList.selectedIndex = 3
        selectionList.selectionImage = UIImage(named: "v")
        selectionList.deselectionImage = UIImage(named: "o")
        selectionList.isSelectionMarkTrailing = false // to put checkmark on left side
        selectionList.rowHeight = 42.0
        
    }
    
   @objc func onSelectionChanged(){
        
    }
  
}
