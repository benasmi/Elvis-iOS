//
//  BaseViewController.swift
//  Elvis
//
//  Created by Martynas Dargis on 02/04/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    // MARK: - Theme
    
    @objc func darkModeEnabled(_ notification: Notification) {
        enableDarkMode()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        disableDarkMode()
    }
    
    open func enableDarkMode() {
        self.view.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    open func disableDarkMode() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .default
    }
}
