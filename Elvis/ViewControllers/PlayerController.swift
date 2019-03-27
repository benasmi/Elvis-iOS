//
//  PlayerController.swift
//  Elvis
//
//  Created by Benas on 26/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SelectionList

class PlayerController: UIViewController {

    var player:AVPlayer?
    var playerItem:AVPlayerItem?

    
    var book: AudioBook!
    var chapters : [String]!
    var selectedChapterIndex : Int = 0
    var selectedChapter: String?
    
   
    @IBOutlet weak var tv_bookTitle: UILabel!
    @IBOutlet weak var tv_time: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var chapterTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chapters = createChapters(book: book)
        print(Utils.readFromSharedPreferences(key: "sessionID"))
        print(book.FileIDs)
        progress.setProgress(0, animated: true)
        tv_bookTitle.text = book.Title
        
        createDayPicker()
    }
    
    @IBAction func play(_ sender: Any) {
        if(player==nil){
             playAudioBook(audioUrl: "http://elvis.labiblioteka.lt/publications/getmediafile/475557/475557.mp3?session_id=ccip6ckgbns4lrkbpd77p31bi4")
             return
        }
        if(player?.rate == 0){
            player?.play()
        }else{
            player?.pause()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func playAudioBook(audioUrl: String){
        let url = URL(string: audioUrl)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
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
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //Creates array of all possible chapters: NOT IMPORTANT
    func createChapters(book: AudioBook) -> [String]{
        var chapterArray : [String] = []
        var x: Int = 0;
        while x < book.FileCount{
            let chapter: String = "SKIRSNIS: " + String(x+1)
            chapterArray.append(chapter)
            x = x + 1
        }
        return chapterArray
    }
    
    //House keeping stuff fro dayPicker: Not IMPORTANT
    func createDayPicker() {
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        
        chapterTextField.inputView = dayPicker
        //Customizations
        dayPicker.backgroundColor = .orange
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Customizations
        toolBar.barTintColor = .orange
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Baigti", style: .plain, target: self, action: #selector(PlayerController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        chapterTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
}

//Chapter picker view: SLIGHTLY IMPORTANT
extension PlayerController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return chapters.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return chapters[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedChapter = chapters[row]
        selectedChapterIndex = row
        chapterTextField.text = selectedChapter
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 25)
        
        label.text = chapters[row]
        
        return label
    }
}
