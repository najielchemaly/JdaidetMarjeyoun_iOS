//
//  EditProfileViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 10/2/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewUsername: UIView!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var viewFullName: UIView!
    @IBOutlet weak var textFieldFullName: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupDelegates()
        self.fillInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolBarView.labelTitle.text = NSLocalizedString("Edit Profile", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if isValidData() {
            self.showWaitOverlay(color: Colors.appBlue)
            DispatchQueue.global(qos: .background).async {
                let userId = DatabaseObjects.user.id == nil ? "" : DatabaseObjects.user.id
                let response = Services.init().editProfile(id: userId!, fullName: self.textFieldFullName.text!, phoneNumber: self.textFieldPhoneNumber.text!, email: self.textFieldEmail.text!, address: self.textFieldAddress.text!)
                
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonUser = json["user"] as? NSDictionary {
                            let user = User.init(dictionary: jsonUser)
                            DatabaseObjects.user = user!
                            
                            let userDefaults = UserDefaults.standard
                            let encodedData = NSKeyedArchiver.archivedData(withRootObject: DatabaseObjects.user)
                            userDefaults.set(encodedData, forKey: "user")
                            
                            userDefaults.synchronize()
                        }
                        
                        if let message = response?.message {
                            DispatchQueue.main.async {
                                self.showAlert(message: message, style: .alert, popVC: true)
                            }
                        }
                    }
                } else {
                    if let message = response?.message {
                        DispatchQueue.main.async {
                            self.showAlert(message: message, style: .alert)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.removeAllOverlays()
                }
            }
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
        
        self.dismissKeyboard()
    }
    
    func initializeViews() {
        self.viewUsername.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewFullName.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewEmail.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewAddress.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewPhoneNumber.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        
        if isReview {
            self.textFieldPhoneNumber.placeholder?.append(" (Optional)")
        }
    }
    
    func setupDelegates() {
        self.textFieldUsername.delegate = self
        self.textFieldFullName.delegate = self
        self.textFieldPhoneNumber.delegate = self
        self.textFieldEmail.delegate = self
        self.textFieldAddress.delegate = self
    }
    
    func fillInfo() {
        self.textFieldUsername.text = DatabaseObjects.user.username
        self.textFieldFullName.text = DatabaseObjects.user.fullName
        self.textFieldPhoneNumber.text = DatabaseObjects.user.phoneNumber
        self.textFieldEmail.text = DatabaseObjects.user.email
        self.textFieldAddress.text = DatabaseObjects.user.address
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if textFieldFullName.text == nil || textFieldFullName.text == "" {
            errorMessage = NSLocalizedString("Fullname Empty", comment: "")
            return false
        }
        if !isReview {
            if textFieldPhoneNumber.text == nil || textFieldPhoneNumber.text == "" {
                errorMessage = NSLocalizedString("Phone Number Empty", comment: "")
                return false
            }
        }
        if textFieldEmail.text == nil || textFieldEmail.text == "" {
            errorMessage = NSLocalizedString("Email Empty", comment: "")
            return false
        }
        if textFieldAddress.text == nil || textFieldAddress.text == "" {
            errorMessage = NSLocalizedString("Address Empty", comment: "")
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldPhoneNumber {
            textFieldFullName.becomeFirstResponder()
        } else if textField == textFieldFullName {
            textFieldEmail.becomeFirstResponder()
        } else if textField == textFieldEmail {
            textFieldAddress.becomeFirstResponder()
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
