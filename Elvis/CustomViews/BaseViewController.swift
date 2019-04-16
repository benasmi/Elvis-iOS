//
//  BaseViewController.swift
//  Elvis
//
//  Created by Benas on 05/04/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit


class BaseViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var isDarkModeEnabled = Utils.readFromSharedPreferences(key: "isDarkModeEnabled") as? Bool
        if(isDarkModeEnabled == nil){
            isDarkModeEnabled = false
        }
        
        isDarkModeEnabled! ? enableDarkMode() : disableDarkMode()
    }
    
    open func toggleMode(){
        let isDarkModeEnabled = !(Utils.readFromSharedPreferences(key: "isDarkModeEnabled") as? Bool ?? false)
        NotificationCenter.default.post(name: isDarkModeEnabled ? .darkModeEnabled : .darkModeDisabled, object: nil)
        Utils.writeToSharedPreferences(key: "isDarkModeEnabled", value: isDarkModeEnabled)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    @objc func darkModeEnabled(_ notification: Notification) {
        enableDarkMode()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        disableDarkMode()
    }
    
   @objc open func enableDarkMode() {
        self.view.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = .black
    }
    
   @objc open func disableDarkMode() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .default
    }
}
