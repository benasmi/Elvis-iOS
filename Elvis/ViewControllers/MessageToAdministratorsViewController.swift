import SVProgressHUD
import UIKit
import Foundation
class MessageToAdministratorsViewController: UIViewController{
    
    
    @IBOutlet weak var messageTopicField: UITextField!
    @IBOutlet weak var messageBodyField: UITextView!
    
    
    
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
    
}
