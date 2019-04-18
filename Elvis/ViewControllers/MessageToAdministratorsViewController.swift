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
        applyAccesibility()
        super.viewDidLoad()
    }
    
    override func disableDarkMode(){
        messageTopicField.textColor = UIColor.black
        messageTopicField.backgroundColor = UIColor.clear
        
        messageBodyField.textColor = UIColor.black
        messageBodyField.backgroundColor = UIColor.clear
        
        messageThemeLabel.textColor = UIColor.black
        messageTextLabel.textColor = UIColor.black
        
        self.view.backgroundColor = UIColor.white
    }
    override func enableDarkMode(){
        messageTopicField.textColor = UIColor.white
        messageTopicField.backgroundColor = UIColor.clear
        
        messageBodyField.textColor = UIColor.white
        messageBodyField.backgroundColor = UIColor.clear
        
        messageThemeLabel.textColor = UIColor.white
        messageTextLabel.textColor = UIColor.white
        
        
        self.view.backgroundColor = UIColor.black
    }
    
}

extension MessageToAdministratorsViewController{
    func applyAccesibility(){
        
        messageTextLabel.isAccessibilityElement = false;
        messageThemeLabel.isAccessibilityElement = false;
        
        messageTopicField.font = UIFont.preferredFont(forTextStyle: .body)
        messageTopicField.adjustsFontForContentSizeCategory = true
        messageTopicField.isAccessibilityElement = true
        messageTopicField.accessibilityTraits = UIAccessibilityTraits.none
        messageTopicField.accessibilityLabel = "Message topic"
        messageTopicField.accessibilityValue = "Click to write topic"
        
        messageBodyField.font = UIFont.preferredFont(forTextStyle: .body)
        messageBodyField.adjustsFontForContentSizeCategory = true
        messageBodyField.isAccessibilityElement = true
        messageBodyField.accessibilityTraits = UIAccessibilityTraits.none
        messageBodyField.accessibilityLabel = "Message content"
        messageBodyField.accessibilityValue = "Click to write message"
        
        sendMsgButton.isAccessibilityElement = true
        sendMsgButton.accessibilityTraits = UIAccessibilityTraits.button
        sendMsgButton.accessibilityLabel = "Click to send message"
        
    }
}




