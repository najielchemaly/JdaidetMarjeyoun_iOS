//
//  ComplaintViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/16/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class ComplaintViewController: BaseViewController, UIPickerViewDelegate, ImagePickerDelegate, PSTextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var viewFullName: UIView!
    @IBOutlet weak var textFieldFullName: PSTextField!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var textFieldPhoneNumber: PSTextField!
    @IBOutlet weak var viewComplaintType: UIView!
    @IBOutlet weak var textFieldComplaintType: PSTextField!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var buttonUpload: UIButton!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var imageUpload: UIImageView!
    
    var pickerView: UIPickerView!
    var selectedComplaintId: String!
    var isDataFoundValid: Bool = false
    var isTextViewEmpty = true
    var placeholder: String!
    
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
        self.viewFullName.customizeBorder(color: Colors.appBlue)
        self.viewPhoneNumber.customizeBorder(color: Colors.appBlue)
        self.viewComplaintType.customizeBorder(color: Colors.appBlue)
        self.textViewDescription.customizeBorder(color: Colors.appBlue)
        
        self.imageUpload.image = #imageLiteral(resourceName: "upload").withRenderingMode(.alwaysTemplate)
        self.imageUpload.tintColor = .white
        
        self.toolBarView.labelTitle.text = NSLocalizedString("Complaints", comment: "")
        self.toolBarView.buttonBack.isHidden = true
        self.toolBarView.buttonMenu.isHidden = true
        
        self.imagePickerDelegate = self
        
        self.textFieldFullName.dataValidationType = .firstName
        self.textFieldPhoneNumber.dataValidationType = .mobileNumber
        self.textFieldComplaintType.dataValidationType = .empty
        
        self.textViewDescription.delegate = self
        self.textViewDescription.text = ""
        self.textViewDidEndEditing(self.textViewDescription)
        
        self.placeholder = NSLocalizedString("Comments", comment: "")
    }

    func setupPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.textFieldComplaintType.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        
        self.textFieldComplaintType.inputAccessoryView = toolbar
    }
    
    func doneButtonTapped() {
        if DatabaseObjects.complaints.count > 0 {
            let row = self.pickerView.selectedRow(inComponent: 0)
            let complaint = DatabaseObjects.complaints[row]
            self.selectedComplaintId = complaint.type
            self.textFieldComplaintType.text = complaint.title
        }
        
        self.dismissKeyboard()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DatabaseObjects.complaints.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DatabaseObjects.complaints[row].title
    }
    
    @IBAction func buttonUploadTapped(_ sender: Any) {
        self.handleCameraTap()
    }
    
    @IBAction func buttonSendTapped(_ sender: Any) {
        if isDataFoundValid && !isTextViewEmpty {
            
        }
    }
    
    //MARK: ImagePicker Delegate
    
    func didFinishPickingMedia(data: UIImage?) {
        if data != nil {
            
        }
    }
    
    func didCancelPickingMedia() {
        
    }
    
    // MARK: PSTextFieldDelegate
    
    func textFieldShouldReturn(_ textField: PSTextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: PSTextField){
        isDataFoundValid = textField.validateInput()
    }
    
    private func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: TextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Colors.lightGray {
            textView.text = ""
            textView.textColor = Colors.text
            
            isTextViewEmpty = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = Colors.lightGray
            
            isTextViewEmpty = true
        }
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
