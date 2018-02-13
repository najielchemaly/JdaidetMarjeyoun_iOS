//
//  ProfileViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/29/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: BaseViewController {

    @IBOutlet weak var viewEditInfo: UIView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var buttonEditInfo: UIButton!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var viewNotifications: UIView!
    @IBOutlet weak var switchNotifications: UISwitch!
    @IBOutlet weak var viewChangeLanguage: UIView!
    @IBOutlet weak var buttonChangeLanguage: UIButton!
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var buttonChangePassword: UIButton!
    @IBOutlet weak var imageArrow1: UIImageView!
    @IBOutlet weak var imageArrow2: UIImageView!
    @IBOutlet weak var viewSignUp: UIView!
    @IBOutlet weak var buttonSignup: UIButton!
    @IBOutlet weak var viewLogout: UIView!
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var imageArrow3: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolBarView.labelTitle.text = NSLocalizedString("Profile", comment: "")
        self.toolBarView.buttonBack.isHidden = true
        self.toolBarView.buttonMenu.isHidden = true
        
        self.fillInfo()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if self.toolBarView != nil {
//            self.scrollView.contentSize.height = self.scrollView.contentSize.height + self.toolBarView.frame.size.height
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonEditInfoTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.EditProfileViewController, type: .Push)
    }

    @IBAction func switchNotificationsValueChanged(_ sender: Any) {
        switchNotifications.isOn = !switchNotifications.isOn
        UserDefaults.standard.set(switchNotifications.isOn, forKey: "receiveNotification")
        
        if switchNotifications.isOn {
            Messaging.messaging().subscribe(toTopic: "/topics/jdeidetmarjeyounnews" + Localization.currentLanguage())
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "/topics/jdeidetmarjeyounnews" + Localization.currentLanguage())
        }
    }
    
    @IBAction func buttonChangeLanguageTapped(_ sender: Any) {
        self.showPopupView(name: "ChangeLanguagePopup")
    }
    
    @IBAction func buttonChangePasswordTapped(_ sender: Any) {
        self.showPopupView(name: "ChangePasswordPopup")
    }
    
    @IBAction func btnSignupTapped(_ sender: Any) {
        if let signupVC = storyboard?.instantiateViewController(withIdentifier: StoryboardIds.SingupViewController) as? SingupViewController {
            signupVC.comingFrom = 2
            self.present(signupVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Are you sure you want to logout?", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Logout", comment: ""), style: .default, handler: { action in
            self.showWaitOverlay(color: Colors.appBlue)
            
            if #available(iOS 10.0, *) {
                _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { timer in
                    self.logout()
                })
            } else {
                // Fallback on earlier versions
                Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.logout), userInfo: nil, repeats: false)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func logout() {
        DispatchQueue.main.async {
            DatabaseObjects.user = User()
            
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "user")
            userDefaults.set(false, forKey: "isUserLoggedIn")
            userDefaults.synchronize()

            self.removeAllOverlays()
            
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIds.LoginViewController) as? LoginViewController {
                appDelegate.window?.rootViewController = loginVC
            }
        }
    }
    
    func initializeViews() {
        self.viewEditInfo.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewName.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewPhone.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewEmail.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewLocation.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewNotifications.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewChangeLanguage.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewChangePassword.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewLogout.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        
        self.imageArrow1.image = Localization.currentLanguage() == "ar" ? #imageLiteral(resourceName: "arrow_left") : #imageLiteral(resourceName: "arrow_right")
        self.imageArrow2.image = Localization.currentLanguage() == "ar" ? #imageLiteral(resourceName: "arrow_left") : #imageLiteral(resourceName: "arrow_right")
        self.imageArrow3.image = Localization.currentLanguage() == "ar" ? #imageLiteral(resourceName: "arrow_left") : #imageLiteral(resourceName: "arrow_right")
    }
    
    func fillInfo() {
        self.labelFullName.text = DatabaseObjects.user.fullName
        self.labelName.text = DatabaseObjects.user.username
        self.labelEmail.text = DatabaseObjects.user.email
        self.labelPhone.text = DatabaseObjects.user.phoneNumber
        self.labelLocation.text = DatabaseObjects.user.address
        
        if let receiveNotification = UserDefaults.standard.value(forKey: "receiveNotification") as? Bool {
            self.switchNotifications.isOn = receiveNotification
        } else {
            self.switchNotifications.isOn = true
            UserDefaults.standard.set(true, forKey: "receiveNotification")
        }
        
        if DatabaseObjects.user.id == nil || DatabaseObjects.user.id == "" {
            self.viewSignUp.isHidden = false
            self.viewChangePassword.isHidden = true
            self.viewLogout.isHidden = true
        } else {
            self.viewSignUp.isHidden = true
            self.viewChangePassword.isHidden = false
            self.viewLogout.isHidden = false
        }
        
        self.buttonSignup.setTitle(NSLocalizedString("Create Your Account", comment: ""), for: .normal)
        self.buttonLogout.setTitle(NSLocalizedString("Logout", comment: ""), for: .normal)
        
        self.checkPlaceHolders()
    }
    
    func checkPlaceHolders() {
        if self.labelFullName.text == nil || self.labelFullName.text == "" {
            self.labelFullName.textColor = Colors.lightGray
            self.labelFullName.text = "Fullname"
        } else {
            self.labelFullName.textColor = Colors.text
        }
        
        if self.labelName.text == nil || self.labelName.text == "" {
            self.labelName.textColor = Colors.lightGray
            self.labelName.text = "Username"
        } else {
            self.labelName.textColor = Colors.text
        }
        
        if self.labelEmail.text == nil || self.labelEmail.text == "" {
            self.labelEmail.textColor = Colors.lightGray
            self.labelEmail.text = "Email"
        } else {
            self.labelEmail.textColor = Colors.text
        }
        
        if self.labelPhone.text == nil || self.labelPhone.text == "" {
            self.labelPhone.textColor = Colors.lightGray
            self.labelPhone.text = "Phone Number"
        } else {
            self.labelPhone.textColor = Colors.text
        }
        
        if self.labelLocation.text == nil || self.labelLocation.text == "" {
            self.labelLocation.textColor = Colors.lightGray
            self.labelLocation.text = "Address"
        } else {
            self.labelLocation.textColor = Colors.text
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
