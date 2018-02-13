//
//  FeesViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/22/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class FeesViewController: BaseViewController, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var viewSection: UIView!
    @IBOutlet weak var viewBlock: UIView!
    @IBOutlet weak var viewYear: UIView!
    @IBOutlet weak var textFieldBlock: PSTextField!
    @IBOutlet weak var textFieldSection: PSTextField!
    @IBOutlet weak var textFieldYear: PSTextField!
    
    var pickerView: UIPickerView!
    var years: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupPickerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.viewSection.customizeBorder(color: Colors.appBlue)
        self.viewBlock.customizeBorder(color: Colors.appBlue)
        self.viewYear.customizeBorder(color: Colors.appBlue)
        
        self.toolBarView.labelTitle.text = NSLocalizedString("Fees", comment: "")
        
        self.years = DatabaseObjects.years
        
        self.textFieldBlock.delegate = self
        self.textFieldSection.delegate = self
    }
    
    func setupPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.textFieldYear.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [doneButton, flexibleSpace, cancelButton]
        
        self.textFieldYear.inputAccessoryView = toolbar
    }
    
    func doneButtonTapped() {
        if self.years.count > 0 {
            let row = self.pickerView.selectedRow(inComponent: 0)
            if let year = self.years[row] as? String {
                self.textFieldYear.text = year
            }
        }
        
        self.dismissKeyboard()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let year = String(describing: self.years[row])
        return year
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let year = self.years[row] as? String {
            self.textFieldYear.text = year
        }
    }

    @IBAction func buttonSearchTapped(_ sender: Any) {
        if isValidData() {
            DatabaseObjects.fees = nil
            self.showWaitOverlay(color: Colors.appBlue)
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().getFees(block_number: self.textFieldBlock.text!, section: self.textFieldSection.text!, year: self.textFieldYear.text!)
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonFees = json["fees"] as? NSDictionary {
                            DatabaseObjects.fees = Fees.init(dictionary: jsonFees)
                        }
                    }
                }
                
                if DatabaseObjects.fees == nil || DatabaseObjects.fees.id == nil {
                    DispatchQueue.main.async {
                        self.showAlert(message: NSLocalizedString("No result found.", comment: ""), style: .alert)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showPopupView(name: "FeesPopup")
                    }
                }
                
                DispatchQueue.main.async {
                    self.removeAllOverlays()
                }
            }
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if textFieldBlock.text == nil || textFieldBlock.text == "" {
            errorMessage = NSLocalizedString("Block Empty", comment: "")
            return false
        }
        if textFieldSection.text == nil || textFieldSection.text == "" {
            errorMessage = NSLocalizedString("Section Empty", comment: "")
            return false
        }
        if textFieldYear.text == nil || textFieldYear.text == "" {
            errorMessage = NSLocalizedString("Year Empty", comment: "")
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textFieldBlock {
            textFieldSection.becomeFirstResponder()
        } else if textField == textFieldSection {
            textFieldYear.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
        }
        
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
