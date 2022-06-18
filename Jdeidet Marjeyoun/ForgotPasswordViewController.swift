//
//  ForgotPasswordViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 3/1/18.
//  Copyright © 2018 marjeyoun-municipality. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var buttonForgotPassword: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var buttonCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setGradientBackground()
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.textFieldEmail.placeholder = NSLocalizedString("Email", comment: "")
        self.buttonCancel.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        self.buttonForgotPassword.setTitle(NSLocalizedString("Reset password", comment: ""), for: .normal)
        
        self.textFieldEmail.delegate = self
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if textFieldEmail.text == nil || textFieldEmail.text == "" {
            errorMessage = NSLocalizedString("Email Empty", comment: "")
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        
        return true
    }
    
    @IBAction func buttonForgotPasswordTapped(_ sender: Any) {
        if isValidData() {
            self.showWaitOverlay(color: Colors.appBlue)
            let email = self.textFieldEmail.text
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().forgotPassword(email: email!)
                DispatchQueue.main.async {
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        if let message = response?.message {
                            self.showAlert(message: message, style: .alert, dismissVC: true)
                        }
                    } else {
                        if let message = response?.message {
                            self.showAlert(message: message, style: .alert)
                        }
                    }
                    
                    self.textFieldEmail.text = ""
                    self.removeAllOverlays()
                }
            }
        } else {
            self.showAlert(message: errorMessage, style: .alert)
        }
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
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
