import SVProgressHUD
import UIKit
import Foundation
class MessageToAdministratorsViewController: BaseViewController, UITextFieldDelegate, UITextViewDelegate{
    
    
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.accessibilityValue = textField.text!
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        //Checking if fields are not empty
        if(messageTopicField.text!.isEmpty || messageBodyField.text!.isEmpty){
             Utils.alertMessage(message: "Ne visi laukeliai užpildyti", title: "Klaida!", buttonTitle: "Bandyti dar kartą!", viewController: self)
            return
        }
        
        //Creating a prompt dialog box
        let alert = UIAlertController(title: "Ar tikrai norite išsiųsti žinutę?", message: "Pasirinkite TAIP arba NE", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "TAIP", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            SVProgressHUD.show(withStatus: "Siunčiama žinutė administratoriams")
            SVProgressHUD.setDefaultMaskType(.black)
            
            DatabaseUtils.sendMessageToAdmins(topic: self.messageTopicField.text!, body: self.messageBodyField.text!, onFinishListener: {
                success in
                SVProgressHUD.dismiss()
                if(!success){
                    Utils.alertMessage(message: "Siunčiant žinutę įvyko klaida", title: "Klaida!", buttonTitle: "Bandyti dar kartą!",viewController: self)
                }else{
                    Utils.alertMessage(message: "Žinutė sėkmingai išsiųsta", title: "", buttonTitle: "Gerai!", viewController: self)
                }
            })
            print ("YES")
        }))
        
        alert.addAction(UIAlertAction(title: "NE", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("NO")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    func textViewDidChange(_ textView: UITextView) {
       messageBodyField.accessibilityValue = messageBodyField.text!
    }
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        applyAccesibility()
        
        messageTopicField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        messageBodyField.delegate = self
        
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
        messageTopicField.accessibilityLabel = "Žinutės tema"
        messageTopicField.accessibilityValue = "Įveskite žinutės temą"
        
        messageBodyField.font = UIFont.preferredFont(forTextStyle: .body)
        messageBodyField.adjustsFontForContentSizeCategory = true
        messageBodyField.isAccessibilityElement = true
        messageBodyField.accessibilityTraits = UIAccessibilityTraits.none
        messageBodyField.accessibilityLabel = "Žinutės turinys"
        messageBodyField.accessibilityValue = "Įvesmite žinutės turinį"
        
        sendMsgButton.isAccessibilityElement = true
        sendMsgButton.accessibilityTraits = UIAccessibilityTraits.button
        sendMsgButton.accessibilityLabel = "Išsiųsti žinutę"
        
    }
}




