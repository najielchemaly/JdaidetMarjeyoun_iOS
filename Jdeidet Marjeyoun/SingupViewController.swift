//
//  SingupViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/11/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class SingupViewController: BaseViewController {

    @IBOutlet weak var viewUsername: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewConfirmPassword: UIView!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var textFieldUsername: PSTextField!
    @IBOutlet weak var textFieldPassword: PSTextField!
    @IBOutlet weak var textFieldConfirmPassword: PSTextField!
    @IBOutlet weak var textFieldPhoneNumber: PSTextField!
    @IBOutlet weak var buttonSignup: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewFullname: UIView!
    @IBOutlet weak var textFieldFullname: PSTextField!
    
//    var isDataFoundValid = false
    var comingFrom: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setGradientBackground()
        self.initialzeViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonSignupTapped(_ sender: Any) {
        if isValidData() {
            self.showPopupView(name: "PopupView")
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
        
        self.dismissKeyboard()
    }
    
    @IBAction func buttonSkipTapped(_ sender: Any) {
        if comingFrom == 1 {
            self.redirectToVC(storyboardId: StoryboardIds.NavigationTabBarController, type: .Present)            
//            if let navTabBar = storyboard?.instantiateViewController(withIdentifier: "navTabBar") as? UINavigationController {
//                appDelegate.window?.rootViewController = navTabBar
//            }
        } else {
            self.dismissVC()
        }
    }

    func initialzeViews() {
//        self.textFieldUsername.dataValidationType = .userName
//        self.textFieldPassword.dataValidationType = .password
//        self.textFieldConfirmPassword.dataValidationType = .confirmPassword
//        self.textFieldPhoneNumber.dataValidationType = .mobileNumber
        
        if isReview {
            self.textFieldPhoneNumber.placeholder?.append(" (Optional)")
        }
    }
    
    // MARK: PSTextFieldDelegate
    
    func textFieldShouldReturn(_ textField: PSTextField) -> Bool {
        if textField == textFieldFullname {
            textFieldUsername.becomeFirstResponder()
        } else if textField == textFieldUsername {
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            textFieldConfirmPassword.becomeFirstResponder()
        } else if textField == textFieldConfirmPassword {
            textFieldPhoneNumber.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: PSTextField){
        
        if textField == textFieldPassword {
            password = textField.text!
        }
        
//        isDataFoundValid = textField.validateInput()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if textFieldFullname.text == nil || textFieldFullname.text == "" {
            errorMessage = NSLocalizedString("Fullname Empty", comment: "")
            return false
        }
        if textFieldUsername.text == nil || textFieldUsername.text == "" {
            errorMessage = NSLocalizedString("Username Empty", comment: "")
            return false
        }
        if textFieldPassword.text == nil || textFieldPassword.text == "" {
            errorMessage = NSLocalizedString("Password Empty", comment: "")
            return false
        }
        if textFieldPassword.text != textFieldConfirmPassword.text {
            errorMessage = NSLocalizedString("Passwords do not match", comment: "")
            return false
        }
        if !isReview {
            if textFieldPhoneNumber.text == nil || textFieldPhoneNumber.text == "" {
                errorMessage = NSLocalizedString("Phone Number Empty", comment: "")
                return false
            }
        }
        if (textFieldPhoneNumber.text?.characters.count)! < 8 {
            errorMessage = NSLocalizedString("Phone Number Invalid", comment: "")
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
