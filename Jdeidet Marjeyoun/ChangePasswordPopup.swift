//
//  PopupView.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/11/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import Foundation

class ChangePasswordPopup: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewConfirmPassword: UIView!
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if let profileVC = currentVC as? ProfileViewController {
            if isValidData() {
                profileVC.dismissKeyboard()
                profileVC.showWaitOverlay(color: Colors.appBlue)
                DispatchQueue.global(qos: .background).async {
                    let response = Services.init().changePassword(id: DatabaseObjects.user.id!, password: self.textFieldPassword.text!)
                    
                    if let message = response?.message {
                        DispatchQueue.main.async {
                            profileVC.showAlert(message: message, style: .alert)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        profileVC.hidePopupView()
                        profileVC.removeAllOverlays()
                    }
                }
            } else {
                profileVC.showAlert(message: errorMessage, style: .alert)
            }
        }
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if textFieldPassword.text == nil || textFieldPassword.text == "" {
            errorMessage = NSLocalizedString("Password Empty", comment: "")
            return false
        }
        
        if textFieldPassword.text != textFieldConfirmPassword.text {
            errorMessage = NSLocalizedString("Passwords do not match", comment: "")
            return false
        }
        
        return true
    }
    
    func setupDelegates() {
        self.textFieldPassword.delegate = self
        self.textFieldConfirmPassword.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldPassword {
            textFieldConfirmPassword.becomeFirstResponder()
        } else {
            if let profileVC = currentVC as? ProfileViewController {
                profileVC.dismissKeyboard()
            }
        }
        
        return true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
