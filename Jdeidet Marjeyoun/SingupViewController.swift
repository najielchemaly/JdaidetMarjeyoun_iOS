//
//  SingupViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/11/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class SingupViewController: BaseViewController, PSTextFieldDelegate {

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
    
    var isDataFoundValid = false
    
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
        
        self.dismissKeyboard()
        
        if isDataFoundValid {
            self.showPopupView(name: "PopupView")
        }
    }
    
    @IBAction func buttonSkipTapped(_ sender: Any) {
        if let navTabBar = storyboard?.instantiateViewController(withIdentifier: "navTabBar") as? UINavigationController {
            appDelegate.window?.rootViewController = navTabBar
        }
    }

    func initialzeViews() {
        self.textFieldUsername.dataValidationType = .userName
        self.textFieldPassword.dataValidationType = .password
        self.textFieldConfirmPassword.dataValidationType = .confirmPassword
        self.textFieldPhoneNumber.dataValidationType = .mobileNumber
    }
    
    // MARK: PSTextFieldDelegate
    
    func textFieldShouldReturn(_ textField: PSTextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: PSTextField){
        
        if textField == textFieldPassword {
            password = textField.text!
        }
        
        isDataFoundValid = textField.validateInput()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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
