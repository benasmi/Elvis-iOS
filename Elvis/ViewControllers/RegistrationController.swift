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
class RegistrationController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var labelLabUser: UILabel!
    @IBOutlet weak var labelHaveDisabilities: UILabel!
    
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSurname: UILabel!
    @IBOutlet weak var labelPersonalCode: UILabel!
    @IBOutlet weak var labelEducation: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelMail: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelAdress: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelDisabilityDescription: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelRepeatPassword: UILabel!
    @IBOutlet weak var btnDocumentsPhoto: UIButton!
    @IBOutlet weak var btnDisabDocumentPhoto: UIButton!
    @IBOutlet weak var labelDocumentPhoto: UILabel!
    @IBOutlet weak var labelDisabDocumentPhoto: UILabel!
    
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
    
    @IBOutlet weak var backgroundView: UIView!
    
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
    
    @IBAction func changeTheme(_ sender: Any) {
        toggleMode()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        prepareEducationDropDown()
        prepareStatusDropDown()
        prepareAddressDropDown()
        prepareGenderDropDown()
        applyAccesibility()
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
        
        let dataSource = ["SILALE", "KAUNAS"]
        
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
        guard !textFieldName.text!.isEmpty else{
            print("tuscias")
            Utils.alertMessage(message: "Vardo laukelis turi būti užpildytas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Last name field empty
        guard !textFieldSurname.text!.isEmpty else{
            Utils.alertMessage(message: "Pavardės laukelis turi būti užpildytas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Personal code field empty
        guard !textFieldPersonalCode.text!.isEmpty else{
            Utils.alertMessage(message: "Asmens kodo laukelis turi būti užpildytas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //email field empty
        guard !textFieldMail.text!.isEmpty else{
            Utils.alertMessage(message: "Pašto laukelis turi būti užpildytas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Mobile phone field empty
        guard !textFieldPhoneNumber.text!.isEmpty else{
            Utils.alertMessage(message: "Telefono numerio laukelis turi būti užpildytas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Mobile phone number field empty
        guard textFieldPhoneNumber.text!.count == 9 else{
            Utils.alertMessage(message: "Telefono numeris turi būti 86XXXXXXX", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Disability description field empty
        guard !textFieldLeagueDescription.text!.isEmpty else{
            Utils.alertMessage(message: "Negalios aprašymo laukelis turi būti užpildytas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Password field empty
        guard !textFieldPassword.text!.isEmpty else{
            Utils.alertMessage(message: "Slaptažodžio laukelis turi būti užpildytas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
                 }
        
        //Repeated password field empty
        guard !textFieldPasswordRepeated.text!.isEmpty else{
            Utils.alertMessage(message: "Slaptažodžio pakartojimo laukelis turi būti užpildytas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        
        
        //Username field empty
        guard !textFieldUsername.text!.isEmpty else{
            Utils.alertMessage(message: "Prisijungimo vardo laukelis turi būti užpildytas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Gender not selected
        guard genderDropDown.indexPathForSelectedRow != nil else{
            Utils.alertMessage(message: "Lyties laukelis turi būti pasirinktas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Education not selected
        guard educationDropDown.indexPathForSelectedRow != nil else{
            Utils.alertMessage(message: "Išsilavinimo laukelis turi būti pasirinktas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Status not selected
        guard statusDropDown.indexPathForSelectedRow != nil else{
            Utils.alertMessage(message: "Statuso laukelis turi būti pasirinktas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Address not selected
        guard addressDropDown.indexPathForSelectedRow != nil else{
            Utils.alertMessage(message: "Adreso laukelis turi būti pasirinktas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Passwords do not match
        guard textFieldPassword.text == textFieldPasswordRepeated.text else{
            Utils.alertMessage(message: "Slaptažodžiai nesutampa!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Invalid personal code
        guard textFieldPersonalCode.text?.count == 11 else{
            Utils.alertMessage(message: "Neteisingas asmens kodas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        let status = statusDropDown.indexPathForSelectedRow!.row+3
        let education = educationDropDown.indexPathForSelectedRow!.row+9
        let muncipality = addressDropDown.indexPathForSelectedRow!.row+1
        let gender = genderDropDown.indexPathForSelectedRow!.row == 0 ? DatabaseUtils.Gender.Vyras : DatabaseUtils.Gender.Moteris
        
        let url = URL(string: "http://haieng.com/wp-content/uploads/2017/10/test-image-500x500.jpg")
        let data = try? Data(contentsOf: url!)
        let testImg = UIImage(data: data!)!
        
     
        //Creating a prompt dialog box
        let alert = UIAlertController(title: "Registruodamiesi sutinkate su Elvis taisyklėmis", message: "Taisykles rasite čia:\n http://elvis.labiblioteka.lt/registration/conditions \n http://elvis.labiblioteka.lt/registration/CommentsConditions", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "TAIP", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            SVProgressHUD.show(withStatus: "Registruojama...")
            
            
            
             DatabaseUtils.register(
             firstName: self.textFieldName.text,
             lastName: self.textFieldSurname.text,
             personalCode: self.textFieldPersonalCode.text,
             birthday: self.datePicker!.date,
             education: education,
             emailAddress: self.textFieldMail.text,
             mobilePhoneNumber: self.textFieldPhoneNumber.text,
             muncipality: muncipality,
             leagueDescription: self.textFieldLeagueDescription.text,
             username: self.textFieldUsername.text,
             password: self.textFieldPassword.text,
             repeatedPassword: self.textFieldPasswordRepeated.text,
             gender: gender,
             status: status,
             haveDisabilities: self.disabilityCheckBox,
             isLabUser: self.labCheckbox,
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
           
             self.dismiss(animated: true, completion: nil)
            
                Utils.alertMessage(message: "Laukite patvirtininmo paštu", title: "Registracija sėkminga!", buttonTitle: "Gerai", viewController: self)
             }
            
            print ("YES")
        }))
        
        alert.addAction(UIAlertAction(title: "NE", style: UIAlertAction.Style.default, handler: { (action) in
            
            print("NO")
        }))
    
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    override func disableDarkMode(){
        
        
        labelDocumentPhoto.textColor = UIColor.black
        labelDisabDocumentPhoto.textColor = UIColor.black
        labelLabUser.textColor = UIColor.black
        labelHaveDisabilities.textColor = UIColor.black
        labelName.textColor = UIColor.black
        labelSurname.textColor = UIColor.black
        labelPersonalCode.textColor = UIColor.black
        labelEducation.textColor = UIColor.black
        labelStatus.textColor = UIColor.black
        labelMail.textColor = UIColor.black
        labelPhoneNumber.textColor = UIColor.black
        labelAdress.textColor = UIColor.black
        labelUsername.textColor = UIColor.black
        labelDisabilityDescription.textColor = UIColor.black
        labelPassword.textColor = UIColor.black
        labelRepeatPassword.textColor = UIColor.black
        labelPersonalCode.textColor = UIColor.black
        labelEducation.textColor = UIColor.black
        labelName.textColor = UIColor.black
        labelSurname.textColor = UIColor.black
        labelPersonalCode.textColor = UIColor.black
        labelEducation.textColor = UIColor.black
        textFieldName.textColor = UIColor.black
        textFieldSurname.textColor = UIColor.black
        textFieldPersonalCode.textColor = UIColor.black
        textFieldMail.textColor = UIColor.black
        textFieldLeagueDescription.textColor = UIColor.black
        textFieldPassword.textColor = UIColor.black
        textFieldPasswordRepeated.textColor = UIColor.black
        textFieldUsername.textColor = UIColor.black
        textFieldPhoneNumber.textColor = UIColor.black
        labelSelectorGender.backgroundColor = UIColor.clear
        labelSelectorGender.textColor = UIColor.black
        datePickerTextInput.backgroundColor = UIColor.clear
        datePickerTextInput.textColor = UIColor.black
        
        self.backgroundView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        
    }
    override func enableDarkMode(){
        labelSelectorGender.backgroundColor = UIColor.clear
        labelSelectorGender.textColor = UIColor.white
        labelDocumentPhoto.textColor = UIColor.white
        labelDisabDocumentPhoto.textColor = UIColor.white
        labelLabUser.textColor = UIColor.white
        labelHaveDisabilities.textColor = UIColor.white
        labelName.textColor = UIColor.white
        labelSurname.textColor = UIColor.white
        labelPersonalCode.textColor = UIColor.white
        labelEducation.textColor = UIColor.white
        labelStatus.textColor = UIColor.white
        labelMail.textColor = UIColor.white
        labelPhoneNumber.textColor = UIColor.white
        labelAdress.textColor = UIColor.white
        labelUsername.textColor = UIColor.white
        labelDisabilityDescription.textColor = UIColor.white
        labelPassword.textColor = UIColor.white
        labelRepeatPassword.textColor = UIColor.white
        labelPersonalCode.textColor = UIColor.white
        labelEducation.textColor = UIColor.white
        labelName.textColor = UIColor.white
        labelSurname.textColor = UIColor.white
        labelPersonalCode.textColor = UIColor.white
        labelEducation.textColor = UIColor.white
        textFieldName.textColor = UIColor.white
        textFieldSurname.textColor = UIColor.white
        textFieldPersonalCode.textColor = UIColor.white
        textFieldMail.textColor = UIColor.white
        textFieldLeagueDescription.textColor = UIColor.white
        textFieldPassword.textColor = UIColor.white
        textFieldPasswordRepeated.textColor = UIColor.white
        textFieldUsername.textColor = UIColor.white
        textFieldPhoneNumber.textColor = UIColor.white
        datePickerTextInput.backgroundColor = UIColor.clear
        datePickerTextInput.textColor = UIColor.white
        
        self.backgroundView.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
    }
    
    
}

extension RegistrationController{
    
    func applyAccesibility(){
        //We don't want blind people to find useless labels
        labelName.isAccessibilityElement = false
        labelSurname.isAccessibilityElement = false
        labelPersonalCode.isAccessibilityElement = false
        labelEducation.isAccessibilityElement = false
        labelStatus.isAccessibilityElement = false
        labelMail.isAccessibilityElement = false
        labelPhoneNumber.isAccessibilityElement = false
        labelAdress.isAccessibilityElement = false
        labelSelectorEducation.isAccessibilityElement = false
        labelSelectorStatus.isAccessibilityElement = false
        labelSelectorAddress.isAccessibilityElement = false
        labelSelectorGender.isAccessibilityElement = false
        labelUsername.isAccessibilityElement = false
        labelDisabilityDescription.isAccessibilityElement = false
        labelPassword.isAccessibilityElement = false
        labelRepeatPassword.isAccessibilityElement = false
        labelDocumentPhoto.isAccessibilityElement = false
        labelDisabDocumentPhoto.isAccessibilityElement = false
        
        textFieldName.isAccessibilityElement = true
        textFieldName.accessibilityLabel = "Name"
        textFieldName.accessibilityValue = "Click to write your name"
        textFieldName.accessibilityTraits = .none
        
        textFieldSurname.isAccessibilityElement = true
        textFieldSurname.accessibilityLabel = "Surname"
        textFieldSurname.accessibilityValue = "Click to write your surname"
        textFieldSurname.accessibilityTraits = .none
        
        textFieldPersonalCode.isAccessibilityElement = true
        textFieldPersonalCode.accessibilityLabel = "Personal code"
        textFieldPersonalCode.accessibilityValue = "Click to write your personal code"
        textFieldPersonalCode.accessibilityTraits = .none
        
        textFieldMail.isAccessibilityElement = true
        textFieldMail.accessibilityLabel = "E-Mail"
        textFieldMail.accessibilityValue = "Click to write your E-mail"
        textFieldMail.accessibilityTraits = .none
        
        textFieldLeagueDescription.isAccessibilityElement = true
        textFieldLeagueDescription.accessibilityLabel = "Disability description"
        textFieldLeagueDescription.accessibilityValue = "Click to write your disability description"
        textFieldLeagueDescription.accessibilityTraits = .none
        
        textFieldPassword.isAccessibilityElement = true
        textFieldPassword.accessibilityLabel = "Password"
        textFieldPassword.accessibilityValue = "Click to write your password"
        
        textFieldPasswordRepeated.isAccessibilityElement = true
        textFieldPasswordRepeated.accessibilityLabel = "Repeat password"
        textFieldPasswordRepeated.accessibilityValue = "Click to repeat your password"
        textFieldPasswordRepeated.accessibilityTraits = .none
        
        textFieldUsername.isAccessibilityElement = true
        textFieldUsername.accessibilityLabel = "Username"
        textFieldUsername.accessibilityValue = "Click to write your username"
        textFieldUsername.accessibilityTraits = .none
        
        textFieldPhoneNumber.isAccessibilityElement = true
        textFieldPhoneNumber.accessibilityLabel = "Phone number"
        textFieldPhoneNumber.accessibilityValue = "Click to write your phone number"
        textFieldPhoneNumber.accessibilityTraits = .none
        
        datePickerTextInput.isAccessibilityElement = true
        datePickerTextInput.accessibilityLabel = "Date selector"
        datePickerTextInput.accessibilityValue = "Click to select your date "
        datePickerTextInput.accessibilityTraits = .none
        
        labelSelectorEducation.isAccessibilityElement = true
        labelSelectorEducation.accessibilityLabel = "Education selector"
        labelSelectorEducation.accessibilityValue = "Click to select your education "
        labelSelectorEducation.accessibilityTraits = .none
        
        labelSelectorStatus.isAccessibilityElement = true
        labelSelectorStatus.accessibilityLabel = "Social status selector"
        labelSelectorStatus.accessibilityValue = "Click to select your social status "
        labelSelectorStatus.accessibilityTraits = .none
        
        labelSelectorAddress.isAccessibilityElement = true
        labelSelectorAddress.accessibilityLabel = "Address selector"
        labelSelectorAddress.accessibilityValue = "Click to select your address "
        labelSelectorAddress.accessibilityTraits = .none
        
        labelSelectorGender.isAccessibilityElement = true
        labelSelectorGender.accessibilityLabel = "Gender selector"
        labelSelectorGender.accessibilityValue = "Click to select your gender "
        labelSelectorGender.accessibilityTraits = .none
        
        
        checkboxLab.isAccessibilityElement = true
        checkboxLab.accessibilityLabel = "I am Lab user checkbox. " + (labCheckbox ? "Selected" : "Not selected")
        checkboxLab.accessibilityValue = "Click to change selection status"
        checkboxLab.accessibilityTraits = .button
        
        checkboxDisabilities.isAccessibilityElement = true
        checkboxDisabilities.accessibilityLabel = "I am disabled checkbox. " + (disabilityCheckBox ? "Selected" : "Not selected")
        checkboxDisabilities.accessibilityValue = "Click to change selection status"
        checkboxDisabilities.accessibilityTraits = .button
        
        
        btnDocumentsPhoto.isAccessibilityElement = true
        btnDocumentsPhoto.accessibilityLabel = "Identity document photo button"
        btnDocumentsPhoto.accessibilityValue = "Click to take photo of your identity document"
        btnDocumentsPhoto.accessibilityTraits = .button
        
        btnDisabDocumentPhoto.isAccessibilityElement = true
        btnDisabDocumentPhoto.accessibilityLabel = "Disability document photo button"
        btnDisabDocumentPhoto.accessibilityValue = "Click to take photo of your disability document"
        btnDisabDocumentPhoto.accessibilityTraits = .button
        
        
        
    }
}
