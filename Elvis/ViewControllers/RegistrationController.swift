//
//  RegistrationController.swift
//  Elvis
//
//  Created by Benas on 25/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
class RegistrationController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSurname: UILabel!
    @IBOutlet weak var labelPersonalCode: UILabel!
    @IBOutlet weak var labelEducation: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelMail: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelAdress: UILabel!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSurname: UITextField!
    @IBOutlet weak var textFieldPersonalCode: UITextField!
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var textFieldLeagueDescription: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldPasswordRepeated: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    
    @IBOutlet weak var datePickerTextInput: UITextField!
    private var datePicker: UIDatePicker?
    
    @IBOutlet weak var labelSelectorEducation: UILabel!
    @IBOutlet weak var labelSelectorStatus: UILabel!
    @IBOutlet weak var labelSelectorAddress: UILabel!
    @IBOutlet weak var labelSelectorGender: UITextField!
    
    @IBOutlet weak var checkboxLab: UIButton!
    @IBOutlet weak var checkboxDisabilities: UIButton!
    
    private var educationDropDown: DropDown!
    private var statusDropDown: DropDown!
    private var addressDropDown: DropDown!
    private var genderDropDown: DropDown!
    
    private var pictureTaken: UIImage?
    private var idPhoto: UIImage?
    private var disabilityDocumentPhoto: UIImage?
    private var imagePicker: UIImagePickerController!
    
    private var labCheckbox: Bool = false
    private var disabilityCheckBox: Bool = false
    
    @IBAction func checkboxLabChecked(_ sender: Any) {
        if(!labCheckbox){
            labCheckbox = true
            checkboxLab.setImage(UIImage(named: "checked"), for: .normal)
        }else{
            labCheckbox = false
            checkboxLab.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
    @IBAction func checkBoxDisabChecked(_ sender: Any) {
        if(!disabilityCheckBox){
            disabilityCheckBox = true
            checkboxDisabilities.setImage(UIImage(named: "checked"), for: .normal)
        }else{
            disabilityCheckBox = false
            checkboxDisabilities.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        prepareEducationDropDown()
        prepareStatusDropDown()
        prepareAddressDropDown()
        prepareGenderDropDown()
        
        let educationTap = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.educationTapListener(sender:)))
        labelSelectorEducation.isUserInteractionEnabled = true
        labelSelectorEducation.addGestureRecognizer(educationTap)
        
        let genderTap = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.genderTapListener(sender:)))
        labelSelectorGender.isUserInteractionEnabled = true
        labelSelectorGender.addGestureRecognizer(genderTap)
        
        let statusTap = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.statusTapListener(sender:)))
        labelSelectorStatus.isUserInteractionEnabled = true
        labelSelectorStatus.addGestureRecognizer(statusTap)
        
        let addressTap = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.addressTapListener(sender:)))
        labelSelectorAddress.isUserInteractionEnabled = true
        labelSelectorAddress.addGestureRecognizer(addressTap)
        
        datePicker = UIDatePicker()
        
        datePicker?.datePickerMode = .date
        
        datePicker?.addTarget(self, action: #selector(RegistrationController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.viewTapped(gestureRecogniser:)))
        
        datePicker?.addGestureRecognizer(tapGesture)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        toolBar.barTintColor = .orange
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Baigti", style: .plain, target: self, action: #selector(RegistrationController.dismissPicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        datePicker?.backgroundColor = .orange
        
        datePickerTextInput.inputAccessoryView = toolBar
        datePickerTextInput.inputView = datePicker
        
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @objc func viewTapped(gestureRecogniser: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func takeIDPhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        pictureTaken = info[.originalImage] as? UIImage
    }
    
    @IBAction func takeDisabilityDocumentPhoto(_ sender: Any) {
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePickerTextInput.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func educationTapListener(sender: UITapGestureRecognizer? = nil){
        educationDropDown.show()
    }
    
    @objc func genderTapListener(sender: UITapGestureRecognizer? = nil){
        genderDropDown.show()
    }
    
    @objc func statusTapListener(sender: UITapGestureRecognizer? = nil){
        statusDropDown.show()
    }
    
    @objc func addressTapListener(sender: UITapGestureRecognizer? = nil){
        addressDropDown.show()
    }
    
    
    func prepareEducationDropDown(){
        educationDropDown = DropDown()
        educationDropDown.anchorView = labelSelectorEducation
        
        let dataSource = Utils.getPlist(withName: "educationList")!

        
        educationDropDown.dataSource = dataSource
        
        // Action triggered on selection
        educationDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.labelSelectorEducation.text = item
            print("Selected item: \(item) at index: \(index)")
        }
    }
    
    func prepareStatusDropDown(){
        statusDropDown = DropDown()
        statusDropDown.anchorView = labelSelectorStatus
        
        let dataSource = Utils.getPlist(withName: "statusList")!
        
        statusDropDown.dataSource = dataSource
        
        // Action triggered on selection
        statusDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.labelSelectorStatus.text = item
            print("Selected item: \(item) at index: \(index)")
        }
    }
    
    func prepareAddressDropDown(){
        addressDropDown = DropDown()
        addressDropDown.anchorView = labelSelectorAddress
        
        let dataSource = Utils.getPlist(withName: "addressList")!

        addressDropDown.dataSource = dataSource
        
        // Action triggered on selection
        addressDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.labelSelectorAddress.text = item
            print("Selected item: \(item) at index: \(index)")
        }
    }
    
    func prepareGenderDropDown(){
        genderDropDown = DropDown()
        genderDropDown.anchorView = labelSelectorGender
        genderDropDown.dataSource = ["Vyras", "Moteris"]
        
        // Action triggered on selection
        genderDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.labelSelectorGender.text = item
            print("Selected item: \(item) at index: \(index)")
        }
    }
    
    
    @IBAction func register(_ sender: Any) {
        
         //First name field empty
         guard let firstName = textFieldName.text else{
         return
         }
         
         //Last name field empty
         guard let lastName = textFieldSurname.text else{
         return
         }
         
         //Personal code field empty
         guard let personalCode = textFieldPersonalCode.text else{
         return
         }
         
         //email field empty
         guard let emailAddress = textFieldMail.text else{
         return
         }
         
         //Mobile phone field empty
         guard let mobilePhoneNumber = textFieldPhoneNumber.text else{
            return
         }
         
         //Mobile phone number field empty
         guard mobilePhoneNumber.count == 9 else{
         //Reiktu parasyti, kad numeris turi buti 86XXXXXXX formatu
         return
         }
         
         //Disability description field empty
         guard let leagueDescription = textFieldLeagueDescription.text else{
         return
         }
         
         //Repeated password field empty
         guard let repeatedPassword = textFieldPasswordRepeated.text else{
         return
         }
         
         //Password field empty
         guard let password = textFieldPassword.text else{
         return
         }
         
         //Username field empty
         guard let username = textFieldUsername.text else{
         return
         }
         
         //Gender not selected
         guard genderDropDown.indexPathForSelectedRow != nil else{
         return
         }
         
         //Education not selected
         guard educationDropDown.indexPathForSelectedRow != nil else{
         return
         }
         
         //Status not selected
         guard statusDropDown.indexPathForSelectedRow != nil else{
         return
         }
         
         //Address not selected
         guard addressDropDown.indexPathForSelectedRow != nil else{
         return
         }
         
         //Passwords do not match
         guard password == repeatedPassword else{
         return
         }
         
         //Invalid personal code
         guard personalCode.count == 11 else{
         return
         }
         
         let status = statusDropDown.indexPathForSelectedRow!.row+3
         let education = educationDropDown.indexPathForSelectedRow!.row+9
         let muncipality = addressDropDown.indexPathForSelectedRow!.row+1
         let gender = genderDropDown.indexPathForSelectedRow!.row == 0 ? DatabaseUtils.Gender.Vyras : DatabaseUtils.Gender.Moteris
 
        let url = URL(string: "http://haieng.com/wp-content/uploads/2017/10/test-image-500x500.jpg")
        let data = try? Data(contentsOf: url!)
        let testImg = UIImage(data: data!)!
        
        SVProgressHUD.show(withStatus: "Registruojama...")
        
        DatabaseUtils.register(
            firstName: firstName,
            lastName: lastName,
            personalCode: personalCode,
            birthday: datePicker!.date,
            education: education,
            emailAddress: emailAddress,
            mobilePhoneNumber: mobilePhoneNumber,
            muncipality: muncipality,
            leagueDescription: leagueDescription,
            username: username,
            password: password,
            repeatedPassword: repeatedPassword,
            gender: gender,
            status: status,
            haveDisabilities: disabilityCheckBox,
            isLabUser: labCheckbox,
            photoID: testImg,
            photoDisabilityDocument: testImg,
            acceptConditions: true,
            acceptCommentConditions: true){
                (error) in
                
                SVProgressHUD.dismiss()
                
                guard error == nil else{
                    
                    switch(error!){
                        case .OutdatedClient:
                            SVProgressHUD.showError(withStatus: "Server responded unexpectedly. Please update the app")
                            return
                        case .InvalidConnection:
                            SVProgressHUD.showError(withStatus: "Connection could not be established.")
                            return
                        case .InvalidInput(let details):
                            SVProgressHUD.showError(withStatus: details)
                            return
                    }
                }
                //Utils.alertMessage(message: "Registracija sėkmings", viewController: self)
                
                self.dismiss(animated: true, completion: nil)
        }
    }
        
        
}
