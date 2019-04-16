//
//  MessagesReceived.swift
//  Elvis
//
//  Created by Benas on 09/04/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import Foundation
import UIKit

class MessagesReceivedViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    var isNightModeEnabled = false;
    @IBOutlet weak var tableView: UITableView!
    var messages: [Message]!
    
    
    override func enableDarkMode(){
        isNightModeEnabled = true
        
        let cells = self.tableView.visibleCells as! Array<MessageCell>
        for cell in cells {
            cell.enableNightMode()
        }
        self.tableView.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
        
        
    }
    @IBAction func changeTheme(_ sender: Any) {
        toggleMode()
    }
    override func disableDarkMode(){
        isNightModeEnabled = false
        
        let cells = self.tableView.visibleCells as! Array<MessageCell>
        for cell in cells {
            cell.disableNightMode()
        }
        
        self.tableView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func chageContrast(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        cell.setUpCell(message: messages[indexPath.row])
        isNightModeEnabled ? cell.enableNightMode() : cell.disableNightMode()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
}
