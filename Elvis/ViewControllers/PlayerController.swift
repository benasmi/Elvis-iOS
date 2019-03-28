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
    var sessionID: String?
   
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var tv_bookTitle: UILabel!
    @IBOutlet weak var tv_time: UILabel!
    @IBOutlet weak var chapterTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chapters = createChapters(book: book)
        sessionID = Utils.readFromSharedPreferences(key: "sessionID")
        
        progressSlider.addTarget(self, action: #selector(PlayerController.playbackSliderValueChanged(_:)), for: .valueChanged)
        
        tv_bookTitle.text = book.Title
        createDayPicker()
    }
    
    @IBAction func play(_ sender: Any) {
        
        if(player==nil){
             let url1 = "http://elvis.labiblioteka.lt/publications/getmediafile/" + book.AudioIDS.FileNormal[selectedChapterIndex]
             let url2 = "/" + book.AudioIDS.FileNormal[selectedChapterIndex] + ".mp3?session_id=" + sessionID!
             let finalUrl = url1 + url2
             playAudioBook(audioUrl: finalUrl)
             playButton.setImage(UIImage(named: "Pause"), for: .normal)
             return
        }
        if(player?.rate == 0){
            player?.play()
            playButton.setImage(UIImage(named: "Pause"), for: .normal)
        }else{
            playButton.setImage(UIImage(named: "Play"), for: .normal)
            player?.pause()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
       
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

        player?.pause()
        player?.rate = 0
        dismiss(animated: true, completion: nil)
    }
    
    func playAudioBook(audioUrl: String){
        let url = URL(string: audioUrl)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        
        let seconds : Float64 = CMTimeGetSeconds(playerItem.asset.duration)
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = Float(seconds)
        progressSlider.isContinuous = true
        progressSlider.tintColor = UIColor.green
        
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
    
  @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    
    
    //Creates array of all possible chapters: NOT IMPORTANT
    func createChapters(book: AudioBook) -> [String]{
        var chapterArray : [String] = []
        var x: Int = 0;
        while x < book.FileCount/2{
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
        
        dayPicker.backgroundColor = .orange
    
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        toolBar.barTintColor = .orange
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Baigti", style: .plain, target: self, action: #selector(PlayerController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        chapterTextField.inputAccessoryView = toolBar
    }
    
    //Triggers when you dismiss the selector
    @objc func dismissKeyboard() {
      
        if(player?.rate != 0){
            playButton.setImage(UIImage(named: "Play"), for: .normal)
            player?.pause()
            player?.rate = 0
            player = nil
        }
        print(selectedChapterIndex)
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
    
    
    //This triggers when you try to select new stuff
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
