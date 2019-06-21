//
//  RegistrationController.swift
//  Elvis
//
//  Created by Benas on 25/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit
import SVProgressHUD
class RegistrationController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    private var currentTextfield: UITextField!
    private var currentTag: Int!
    
    private var educationValues : [String]!
    private var statusValues: [String]!
    private var addressValues: [String]!
    private var genderValues: [String]!
    
    private var selectedEducationRow: Int = -1
    private var selectedStatusRow: Int = -1
    private var selectedAddressRow: Int = -1
    private var selectedGenderRow: Int = -1
    
    @IBOutlet weak var educationTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var goBackButton: UIButton!
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

    @IBOutlet weak var checkboxLab: UIButton!
    @IBOutlet weak var checkboxDisabilities: UIButton!
    
    private var pictureTaken: UIImage?
    
    private var idPhoto: UIImage?
    private var disabilityDocumentPhoto: UIImage?
    
    private var imagePicker: UIImagePickerController!
    
    private var takingIDPhoto: Bool = false
    private var labCheckbox: Bool = false
    private var disabilityCheckBox: Bool = false
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.accessibilityValue = textField.text!
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextfield = textField
        return true
    }
    
    func createPlistValues(){
        educationValues = Utils.getPlist(withName: "educationList")!
        statusValues = Utils.getPlist(withName: "statusList")!
        addressValues = Utils.getPlist(withName: "addressList")!
        genderValues = ["Vyras                                        ", "Moteris                                        "]
    }
    
    
    @IBAction func checkboxLabChecked(_ sender: Any) {
        if(!labCheckbox){
            labCheckbox = true
            checkboxLab.setImage(UIImage(named: "checked"), for: .normal)
        }else{
            labCheckbox = false
            checkboxLab.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        checkboxLab.accessibilityLabel = "Esu LAB vartotojas" + (labCheckbox ? "Pažymėta" : "Nepažymėta")
        
       
        
        
    }
    
    
    @IBAction func checkBoxDisabChecked(_ sender: Any) {
        if(!disabilityCheckBox){
            disabilityCheckBox = true
            checkboxDisabilities.setImage(UIImage(named: "checked"), for: .normal)
        }else{
            disabilityCheckBox = false
            checkboxDisabilities.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        checkboxDisabilities.accessibilityLabel = "Turiu negalią" + (disabilityCheckBox ? "Pazymeta" : "Nepažymėta")
        
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        toggleMode()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //House keeping stuff fro dayPicker: Not IMPORTANT
    func createPicker() {
        let picker = UIPickerView()
        picker.delegate = self
        
        educationTextField.inputView = picker
        statusTextField.inputView = picker
        addressTextField.inputView = picker
        genderTextField.inputView = picker
        
        picker.backgroundColor = .orange
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        toolBar.barTintColor = .orange
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Baigti", style: .plain, target: self, action: #selector(RegistrationController.dismissAnyPickers))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        educationTextField.inputAccessoryView = toolBar
        statusTextField.inputAccessoryView = toolBar
        addressTextField.inputAccessoryView = toolBar
        genderTextField.inputAccessoryView = toolBar
        
    }
 
    
    @objc func dismissAnyPickers(){
   
        
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
       
        createPlistValues()
        createPicker()
        
        educationTextField.delegate = self
        statusTextField.delegate = self
        genderTextField.delegate = self
        addressTextField.delegate = self
        
        
        textFieldName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textFieldSurname.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textFieldPersonalCode.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textFieldMail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textFieldLeagueDescription.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textFieldPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textFieldPasswordRepeated.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textFieldUsername.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textFieldPhoneNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        applyAccesibility()
        
        
        btnDocumentsPhoto.titleLabel?.numberOfLines = 1
        btnDocumentsPhoto.titleLabel?.adjustsFontSizeToFitWidth = true
        btnDocumentsPhoto.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        btnDisabDocumentPhoto.titleLabel?.numberOfLines = 1
        btnDisabDocumentPhoto.titleLabel?.adjustsFontSizeToFitWidth = true
        btnDisabDocumentPhoto.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping

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
        datePicker?.setValue(UIColor.white, forKey: "textColor")
        
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
        takingIDPhoto = true
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setPhotos(image: UIImage, isID: Bool){
        if(isID){
            idPhoto = image
            btnDocumentsPhoto.accessibilityLabel = "ID Dokumento nuotrauka jau padaryta. Ar norite pakartoti?"
            btnDocumentsPhoto.titleLabel?.text = "DARYTI NAUJĄ NUOTRAUKĄ"
        }else{
            btnDisabDocumentPhoto.titleLabel?.text = "DARYTI NAUJĄ NUOTRAUKĄ"
            btnDisabDocumentPhoto.accessibilityLabel = "Neįgalumo dokumento nuotrauka jau padaryta. Ar norite pakartoti?"
            disabilityDocumentPhoto = image
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imagePicker.dismiss(animated: true, completion: nil)
            pictureTaken = info[.originalImage] as? UIImage
            setPhotos(image: pictureTaken!, isID: takingIDPhoto)
    }
    @IBAction func takeDisabilityDocumentPhoto(_ sender: Any) {
        takingIDPhoto = false
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePickerTextInput.text = dateFormatter.string(from: datePicker.date)
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
        guard selectedGenderRow != -1 else{
            Utils.alertMessage(message: "Lyties laukelis turi būti pasirinktas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Education not selected
        guard selectedEducationRow != -1 else{
            Utils.alertMessage(message: "Išsilavinimo laukelis turi būti pasirinktas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Status not selected
        guard selectedStatusRow != -1 else{
            Utils.alertMessage(message: "Statuso laukelis turi būti pasirinktas!", title: "Klaida!", buttonTitle: "Gerai", viewController: self)
            return
        }
        
        //Address not selected
        guard selectedAddressRow != -1 else{
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
        
        let status = selectedStatusRow+3
        let education = selectedEducationRow+9
        let muncipality = selectedAddressRow+1
        let gender = selectedGenderRow == 0 ? DatabaseUtils.Gender.Vyras : DatabaseUtils.Gender.Moteris
        
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
             photoID: self.idPhoto!,
             photoDisabilityDocument: self.disabilityDocumentPhoto!,
             acceptConditions: true,
             acceptCommentConditions: true){
             (error) in
             
             SVProgressHUD.dismiss()
             
             guard error == nil else{
             
             switch(error!){
             case .OutdatedClient:
             SVProgressHUD.showError(withStatus: "Klaida! Atnaujinkite aplikaciją")
             return
             case .InvalidConnection:
             SVProgressHUD.showError(withStatus: "Prisijungti prie serverio nepavyko")
             return
             case .InvalidInput(let details):
             SVProgressHUD.showError(withStatus: details)
             return
             }
             }
              
                
                //Creating a prompt dialog box
                let successAlert = UIAlertController(title: "Registracija sėkminga!", message: "Laukite patvirtinimo paštu", preferredStyle: UIAlertController.Style.alert)
                
                successAlert.addAction(UIAlertAction(title: "Gerai", style: UIAlertAction.Style.default, handler: { (action) in
                    
                        self.dismiss(animated: true, completion: nil)
                    
                }))
                self.present(successAlert, animated: true, completion: nil)
            
            
            
               
             }
            
            print ("Taip")
        }))
        
        alert.addAction(UIAlertAction(title: "NE", style: UIAlertAction.Style.default, handler: { (action) in
            
            print("Ne")
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
        
        educationTextField.backgroundColor = UIColor.clear
        educationTextField.textColor = UIColor.black
        
        
        addressTextField.backgroundColor = UIColor.clear
        addressTextField.textColor = UIColor.black
 
        genderTextField.backgroundColor = UIColor.clear
        genderTextField.textColor = UIColor.black
 
        statusTextField.backgroundColor = UIColor.clear
        statusTextField.textColor = UIColor.black
        
        datePickerTextInput.backgroundColor = UIColor.clear
        datePickerTextInput.textColor = UIColor.black
        
        self.backgroundView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        
    }
    override func enableDarkMode(){
        
        educationTextField.backgroundColor = UIColor.clear
        educationTextField.textColor = UIColor.white
       
        addressTextField.backgroundColor = UIColor.clear
        addressTextField.textColor = UIColor.white
 
        genderTextField.backgroundColor = UIColor.clear
        genderTextField.textColor = UIColor.white
 
        statusTextField.backgroundColor = UIColor.clear
        statusTextField.textColor = UIColor.white
        
        
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

extension RegistrationController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(currentTextfield.tag == 1){
            return educationValues.count
        }
        if(currentTextfield.tag == 2){
            return statusValues.count
        }
        if(currentTextfield.tag == 3){
            return addressValues.count
        }
        if(currentTextfield.tag == 4){
            return genderValues.count
        }
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(currentTextfield.tag == 1){
            return educationValues[row]
        }
        if(currentTextfield.tag == 2){
            return statusValues[row]
        }
        if(currentTextfield.tag == 3){
            return addressValues[row]
        }
        if(currentTextfield.tag == 4){
            return genderValues[row]
        }
        
        return ""
    }
    
    
    //This triggers when you try to select new stuff
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(currentTextfield.tag == 1){
            selectedEducationRow = row
            educationTextField.text = educationValues[row]
             educationTextField.accessibilityLabel = "Išsilavinimo pasirinkimas" + educationTextField.text!
        }
        if(currentTextfield.tag == 2){
            selectedStatusRow = row
            statusTextField.text = statusValues[row]
            statusTextField.accessibilityLabel = "Statuso pasirinkimas" + statusTextField.text!
        }
        if(currentTextfield.tag == 3){
            selectedAddressRow = row
            addressTextField.text = addressValues[row]
            addressTextField.accessibilityLabel = "Adreso pasirinkimas" + addressTextField.text!
        }
        if(currentTextfield.tag == 4){
            selectedGenderRow = row
            genderTextField.text = genderValues[row]
            genderTextField.accessibilityLabel = "Lyties pasirinkimas" + genderTextField.text!
        }
        
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
        
        
      
        
        if(currentTextfield.tag == 1){
            label.text = educationValues[row]
   
        }
        if(currentTextfield.tag == 2){
            label.text = statusValues[row]
    
        }
        if(currentTextfield.tag == 3){
            label.text = addressValues[row]
    
        }
        if(currentTextfield.tag == 4){
            label.text = genderValues[row]
           
        }
        
        
        label.isAccessibilityElement = true
        return label
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
        labelUsername.isAccessibilityElement = false
        labelDisabilityDescription.isAccessibilityElement = false
        labelPassword.isAccessibilityElement = false
        labelRepeatPassword.isAccessibilityElement = false
        labelDocumentPhoto.isAccessibilityElement = false
        labelDisabDocumentPhoto.isAccessibilityElement = false
        
        textFieldName.isAccessibilityElement = true
        textFieldName.accessibilityLabel = "Vardas" + textFieldName.text!
        textFieldName.accessibilityValue = "Įveskite vardą"
        textFieldName.accessibilityTraits = .none
        
        goBackButton.isAccessibilityElement = true
        goBackButton.accessibilityLabel = "Grįžti Atgal"
        
        textFieldSurname.isAccessibilityElement = true
        textFieldSurname.accessibilityLabel = "Pavardė" + textFieldSurname.text!
        textFieldSurname.accessibilityValue = "Įveskite pavardę"
        textFieldSurname.accessibilityTraits = .none
        
        textFieldPersonalCode.isAccessibilityElement = true
        textFieldPersonalCode.accessibilityLabel = "Asmens kodas" + textFieldPersonalCode.text!
        textFieldPersonalCode.accessibilityValue = "Įveskite asmens kodą"
        textFieldPersonalCode.accessibilityTraits = .none
        
        textFieldMail.isAccessibilityElement = true
        textFieldMail.accessibilityLabel = "Paštas" + textFieldMail.text!
        textFieldMail.accessibilityValue = "Įveskite savo paštą"
        textFieldMail.accessibilityTraits = .none
        
        textFieldLeagueDescription.isAccessibilityElement = true
        textFieldLeagueDescription.accessibilityLabel = "Negalios aprašymas" + textFieldLeagueDescription.text!
        textFieldLeagueDescription.accessibilityValue = "Įveskite negalios aprašymą"
        textFieldLeagueDescription.accessibilityTraits = .none
        
        textFieldPassword.isAccessibilityElement = true
        textFieldPassword.accessibilityLabel = "Slaptažodis" + textFieldPassword.text!
        textFieldPassword.accessibilityValue = "Įveskite slaptažpdį"
        
        textFieldPasswordRepeated.isAccessibilityElement = true
        textFieldPasswordRepeated.accessibilityLabel = "Pakartoti slaptažodį" + textFieldPasswordRepeated.text!
        textFieldPasswordRepeated.accessibilityValue = "Įveskite slaptažodį dar kartą"
        textFieldPasswordRepeated.accessibilityTraits = .none
        
        textFieldUsername.isAccessibilityElement = true
        textFieldUsername.accessibilityLabel = "Prisijungimo vardas" + textFieldUsername.text!
        textFieldUsername.accessibilityValue = "Įveskite prisijungimo vardą"
        textFieldUsername.accessibilityTraits = .none
        
        textFieldPhoneNumber.isAccessibilityElement = true
        textFieldPhoneNumber.accessibilityLabel = "Telefono numeris" + textFieldPhoneNumber.text!
        textFieldPhoneNumber.accessibilityValue = "Įveskite telefono numerį"
        textFieldPhoneNumber.accessibilityTraits = .none
        
        datePickerTextInput.isAccessibilityElement = true
        datePickerTextInput.accessibilityLabel = "Datos pasirinkimas" + datePickerTextInput.text!
        datePickerTextInput.accessibilityValue = "Pasirinkite datą"
        datePickerTextInput.accessibilityTraits = .none
        
        
        educationTextField.isAccessibilityElement = true
        educationTextField.accessibilityLabel = "Išsilavinimo pasirinkimas" + educationTextField.text!
        educationTextField.accessibilityValue = "Pasirinkimas apačioje"
        educationTextField.accessibilityTraits = .button
 
        statusTextField.isAccessibilityElement = true
        statusTextField.accessibilityLabel = "Statuso pasirinkimas" + educationTextField.text!
        statusTextField.accessibilityValue = "Pasirinkimas apačioje"
        statusTextField.accessibilityTraits = .none
 
        addressTextField.isAccessibilityElement = true
        addressTextField.accessibilityLabel = "Adreso pasirinkimas" + addressTextField.text!
        addressTextField.accessibilityValue = "Pasirinkimas apačioje"
        addressTextField.accessibilityTraits = .none
        
        genderTextField.isAccessibilityElement = true
        genderTextField.accessibilityLabel = "Lyties pasirinkimas" + genderTextField.text!
        genderTextField.accessibilityValue = "Pasirinkimas apačioje"
        genderTextField.accessibilityTraits = .none
        
        
        checkboxLab.isAccessibilityElement = true
        checkboxLab.accessibilityLabel = "Esu LAB vartotojas" + (labCheckbox ? "Pažymėta" : "Nepažymėta")
        checkboxLab.accessibilityTraits = .button
        
        checkboxDisabilities.isAccessibilityElement = true
        checkboxDisabilities.accessibilityLabel = "Turiu negalią" + (disabilityCheckBox ? "Pazymeta" : "Nepažymėta")
        checkboxDisabilities.accessibilityTraits = .button
        
        
        btnDocumentsPhoto.isAccessibilityElement = true
        btnDocumentsPhoto.accessibilityLabel = "ID nuotrauka nepadaryta"
        btnDocumentsPhoto.accessibilityValue = "Padarykite ID nuotrauką"
        btnDocumentsPhoto.accessibilityTraits = .button
        
        btnDisabDocumentPhoto.isAccessibilityElement = true
        btnDisabDocumentPhoto.accessibilityLabel = "Neįgalumo dokumento nuotrauka nepadaryta"
        btnDisabDocumentPhoto.accessibilityValue = "Padarykite neįgalumo dokumento nuotrauką"
        btnDisabDocumentPhoto.accessibilityTraits = .button
        
        
        
    }
}
