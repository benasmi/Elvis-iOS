import SVProgressHUD
import UIKit
import Foundation
class MessageToAdministratorsViewController: BaseViewController{
    
    
    @IBOutlet weak var messageTopicField: UITextField!
    @IBOutlet weak var messageBodyField: UITextView!
    @IBOutlet weak var messageThemeLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var sendMsgButton: UIButton!
    
    @IBAction func changeTheme(_ sender: Any) {
        toggleMode()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Siunčiama žinutė administratoriams")
        SVProgressHUD.setDefaultMaskType(.black)
        
        DatabaseUtils.sendMessageToAdmins(topic: messageTopicField.text!, body: messageBodyField.text!, onFinishListener: {
            success in
            SVProgressHUD.dismiss()
            if(!success){
                SVProgressHUD.showInfo(withStatus: "Siunčiant žinutę įvyko klaida")
            }
        })
    }
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
    }
    
    override func disableDarkMode(){
        messageTopicField.textColor = UIColor.black
        messageTopicField.backgroundColor = UIColor.clear
        
        messageBodyField.textColor = UIColor.black
        messageBodyField.backgroundColor = UIColor.clear
        
        messageThemeLabel.textColor = UIColor.black
        messageThemeLabel.textColor = UIColor.black
        
        self.view.backgroundColor = UIColor.white
    }
    override func enableDarkMode(){
        messageTopicField.textColor = UIColor.white
        messageTopicField.backgroundColor = UIColor.clear
        
        messageBodyField.textColor = UIColor.white
        messageBodyField.backgroundColor = UIColor.clear
        
        messageThemeLabel.textColor = UIColor.white
        messageThemeLabel.textColor = UIColor.white
        
        
        self.view.backgroundColor = UIColor.black
    }
    
}
