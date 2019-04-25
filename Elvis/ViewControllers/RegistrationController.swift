//
//  RegistrationController.swift
//  Elvis
//
//  Created by Benas on 25/03/2019.
//  Copyright © 2019 RM-Elvis. All rights reserved.
//

import UIKit
import DropDown

class RegistrationController: UIViewController {

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
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    
    
    @IBOutlet weak var labelSelectorEducation: UILabel!
    @IBOutlet weak var labelSelectorStatus: UILabel!
    @IBOutlet weak var labelSelectorAddress: UILabel!
    
    @IBOutlet weak var checkboxLab: UIButton!
    @IBOutlet weak var checkboxDisabilities: UIButton!
    
    
    
    private var educationDropDown: DropDown!
    private var statusDropDown: DropDown!
    private var addressDropDown: DropDown!
 
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
        
        
        let educationTap = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.educationTapListener(sender:)))
        labelSelectorEducation.isUserInteractionEnabled = true
        labelSelectorEducation.addGestureRecognizer(educationTap)
        
        let statusTap = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.statusTapListener(sender:)))
        labelSelectorStatus.isUserInteractionEnabled = true
        labelSelectorStatus.addGestureRecognizer(statusTap)
        
        let addressTap = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.addressTapListener(sender:)))
        labelSelectorAddress.isUserInteractionEnabled = true
        labelSelectorAddress.addGestureRecognizer(addressTap)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func educationTapListener(sender: UITapGestureRecognizer? = nil){
        educationDropDown.show()
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
        educationDropDown.dataSource = ["PRADINIS", "PAGRINDINIS", "VIDURINIS", "AUKŠTASIS", "AUKŠTESNYSIS", "PROFESINIS"]
        
        // Action triggered on selection
        educationDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
        }
    }
    
    func prepareStatusDropDown(){
        statusDropDown = DropDown()
        statusDropDown.anchorView = labelSelectorStatus
        statusDropDown.dataSource = ["MOKSLEIVIS", "STUDENTAS", "DIRBANTYSIS", "BEDARBIS", "PENSININKAS", "KITAS"]
        
        // Action triggered on selection
        statusDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
        }
    }
    
    func prepareAddressDropDown(){
        addressDropDown = DropDown()
        addressDropDown.anchorView = labelSelectorAddress
        addressDropDown.dataSource = ["KAUNAS", "VILNIUS", "ŠILALĖ"]
        
        // Action triggered on selection
        addressDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
        }
    }
    
    
    
}
