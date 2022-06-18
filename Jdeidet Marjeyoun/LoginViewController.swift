//
//  LoginViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 11/20/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var viewUsername: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var forgotPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setGradientBackground()
        self.getGlobalVariables()
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.ForgotPasswordViewController, type: .Present)
    }
    
    @IBAction func buttonLoginTapped(_ sender: Any) {
        if isValidData() {
            self.showWaitOverlay(color: Colors.appBlue)
            DispatchQueue.global(qos: .background).async {
                let response = Services.init().login(username: self.textFieldUsername.text!, password: self.textFieldPassword.text!)
                
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonUser = json["user"] as? NSDictionary {
                            let user = User.init(dictionary: jsonUser)
                            DatabaseObjects.user = user!
                            
                            DispatchQueue.main.async {
                                let userDefaults = UserDefaults.standard
                                userDefaults.set(true, forKey: "isUserLoggedIn")
                                
                                let encodedData = NSKeyedArchiver.archivedData(withRootObject: DatabaseObjects.user)
                                userDefaults.set(encodedData, forKey: "user")
                                
                                userDefaults.synchronize()

                                self.redirectToVC(storyboardId: StoryboardIds.NavigationTabBarController, type: .Present)
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
    }
    
    @IBAction func buttonRegisterTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.SingupViewController, type: .Present)
    }
    
    @IBAction func buttonSkipTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.NavigationTabBarController, type: .Present)
    }
    
    func initializeViews() {
        self.labelTitle.text = NSLocalizedString("Login", comment: "")
        self.textFieldUsername.placeholder = NSLocalizedString("Username", comment: "")
        self.textFieldPassword.placeholder = NSLocalizedString("Password", comment: "")
        self.buttonLogin.setTitle(NSLocalizedString("Sign in", comment: ""), for: .normal)
        self.buttonRegister.setTitle(NSLocalizedString("Register", comment: ""), for: .normal)
        self.buttonSkip.setTitle(NSLocalizedString("Skip", comment: ""), for: .normal)
        self.forgotPassword.setTitle(NSLocalizedString("Forgot password", comment: ""), for: .normal)
        
        self.textFieldUsername.delegate = self
        self.textFieldPassword.delegate = self
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if textFieldUsername.text == nil || textFieldUsername.text == "" {
            errorMessage = NSLocalizedString("Username Empty", comment: "")
            return false
        }
        if textFieldPassword.text == nil || textFieldPassword.text == "" {
            errorMessage = NSLocalizedString("Password Empty", comment: "")
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if textField == textFieldUsername {
            textFieldPassword.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
        }
        
        return true
    }
    
    func getGlobalVariables() {
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getGlobalVariables()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let is_review = json["is_review"] as? Bool {
                        isReview = is_review
                    }
                    if let is_comingsoon = json["is_comingsoon"] as? Bool {
                        isComingSoon = is_comingsoon
                    }
                }
            }
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
