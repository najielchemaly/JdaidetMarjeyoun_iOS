//
//  ProfileViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/29/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonEditInfoTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.EditProfileViewController, type: .Push)
    }

    @IBAction func switchNotificationsValueChanged(_ sender: Any) {
        
    }
    
    @IBAction func buttonChangeLanguageTapped(_ sender: Any) {
        self.showPopupView(name: "ChangeLanguagePopup")
    }
    
    @IBAction func buttonChangePasswordTapped(_ sender: Any) {
        self.showPopupView(name: "ChangePasswordPopup")
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
        
        self.imageArrow1.image = Localization.currentLanguage() == "ar" ? #imageLiteral(resourceName: "arrow_left") : #imageLiteral(resourceName: "arrow_right")
        self.imageArrow2.image = Localization.currentLanguage() == "ar" ? #imageLiteral(resourceName: "arrow_left") : #imageLiteral(resourceName: "arrow_right")
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
