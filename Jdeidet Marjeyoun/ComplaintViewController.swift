//
//  ComplaintViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/16/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class ComplaintViewController: BaseViewController, UIPickerViewDelegate, ImagePickerDelegate, PSTextFieldDelegate, UITextViewDelegate, UITextFieldDelegate {

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
//    var isDataFoundValid: Bool = false
    var isTextViewEmpty = true
    var placeholder: String!
    var selectedImage: UIImage!
    
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
        
//        self.textFieldFullName.dataValidationType = .firstName
//        self.textFieldPhoneNumber.dataValidationType = .mobileNumber
//        self.textFieldComplaintType.dataValidationType = .empty
        
        self.textViewDescription.delegate = self
        self.textViewDescription.text = ""
        self.textViewDidEndEditing(self.textViewDescription)
        
        self.placeholder = NSLocalizedString("Comments", comment: "")
        
        self.textFieldFullName.delegate = self
        self.textFieldPhoneNumber.delegate = self
        self.textFieldComplaintType.delegate = self
    }

    func setupPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.textFieldComplaintType.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [doneButton, flexibleSpace, cancelButton]
        
        self.textFieldComplaintType.inputAccessoryView = toolbar
    }
    
    func doneButtonTapped() {
        if DatabaseObjects.complaintsTypes.count > 0 {
            let row = self.pickerView.selectedRow(inComponent: 0)
            let complaint = DatabaseObjects.complaintsTypes[row]
            if let complaintId = complaint.id {
                self.selectedComplaintId = String(describing: complaintId)
            }
            self.textFieldComplaintType.text = complaint.title
        }
        
        self.dismissKeyboard()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DatabaseObjects.complaintsTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DatabaseObjects.complaintsTypes[row].title
    }
    
    @IBAction func buttonUploadTapped(_ sender: Any) {
        self.handleCameraTap()
    }
    
    @IBAction func buttonSendTapped(_ sender: Any) {
        if isValidData() {
            if self.selectedImage == nil {
                let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Are you sure you want to send a complaint without a photo?", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: NSLocalizedString("Send", comment: ""), style: .default, handler: { action in
                    self.sendComplaintWithoutMedia()
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.sendComplaintWithMedia()
            }
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
    }
    
    func sendComplaintWithoutMedia() {
        self.showWaitOverlay(color: Colors.appBlue)
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().sendComplaint(fullName: self.textFieldFullName.text!, phoneNumber: self.textFieldPhoneNumber.text!, complaintType: self.textFieldComplaintType.text!, description: self.textViewDescription.text!)
        
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                DispatchQueue.main.async {
                    self.resetFields()
                }
            }
        
            if let message = response?.message {
                DispatchQueue.main.async {
                    self.showAlert(message: message, style: .alert)
                }
            }
        
            DispatchQueue.main.async {
                self.removeAllOverlays()
            }
        }
    }
    
    func sendComplaintWithMedia() {
        self.showWaitOverlay(color: Colors.appBlue)
        DispatchQueue.global(qos: .background).async {
            Services.init().uploadImageData(imageFile: self.selectedImage, completion: { data in
                if let json = data.json?.first {
                    if let dataId = json["id"] as? Int {
                        let response = Services.init().sendComplaint(dataId: String(describing: dataId), fullName: self.textFieldFullName.text!, phoneNumber: self.textFieldPhoneNumber.text!, complaintType: self.textFieldComplaintType.text!, description: self.textViewDescription.text!)
                        
                        if response?.status == ResponseStatus.SUCCESS.rawValue {
                            DispatchQueue.main.async {
                                self.resetFields()
                            }
                        }
                        
                        if let message = response?.message {
                            DispatchQueue.main.async {
                                self.showAlert(message: message, style: .alert)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if !data.message.isEmpty {
                            self.showAlert(message: data.message, style: .alert)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.removeAllOverlays()
                }
            })
        }
    }
    
    func resetFields() {
        self.textFieldFullName.text = nil
        self.textFieldPhoneNumber.text = nil
        self.textFieldComplaintType.text = nil
        self.textViewDescription.text = nil
        
        self.didCancelPickingMedia()
    }
    
    //MARK: ImagePicker Delegate
    
    func didFinishPickingMedia(data: UIImage?) {
        if let image = data {
            self.selectedImage = image
            self.buttonUpload.setTitle(NSLocalizedString("Uploaded", comment: ""), for: .normal)
        } else {
            self.buttonUpload.setTitle(NSLocalizedString("Upload", comment: ""), for: .normal)
        }
    }
    
    func didCancelPickingMedia() {
        self.selectedImage = nil
        self.buttonUpload.setTitle(NSLocalizedString("Upload", comment: ""), for: .normal)
    }
    
    // MARK: PSTextFieldDelegate
    
    func textFieldShouldReturn(_ textField: PSTextField) -> Bool {
        if textField == textFieldFullName {
            textFieldPhoneNumber.becomeFirstResponder()
        } else if textField == textFieldPhoneNumber {
            textFieldComplaintType.becomeFirstResponder()
        } else if textField == textFieldComplaintType {
            textViewDescription.becomeFirstResponder()
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: PSTextField){
//        isDataFoundValid = textField.validateInput()
    }
    
    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if textFieldFullName.text == nil || textFieldFullName.text == "" ||
        textFieldPhoneNumber.text == nil || textFieldPhoneNumber.text == "" ||
        textFieldComplaintType.text == nil || textFieldComplaintType.text == "" ||
            textViewDescription.text == nil || textViewDescription.text == "" {
            errorMessage = NSLocalizedString("Data Required", comment: "")
            return false
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
