//
//  SelectLanguageViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/11/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class SelectLanguageViewController: BaseViewController {

    @IBOutlet weak var buttonArabic: UIButton!
    @IBOutlet weak var buttonEnglish: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    
    var comingFrom: Int = ComingFrom.launch.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setGradientBackground()
        
        if currentVC is ProfileViewController {
            self.buttonClose.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
            self.buttonClose.imageView?.tintColor = Colors.appBlue
            self.buttonClose.isHidden = false
            
            self.comingFrom = ComingFrom.profile.rawValue
        } else {
            self.buttonClose.isHidden = true
            self.comingFrom = ComingFrom.launch.rawValue
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonLanguageTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            if button.tag == SelectedLanguage.arabic.rawValue {
                Localization.setLanguageTo("ar")
            } else {
                Localization.setLanguageTo("en")
            }
            
            if UserDefaults.standard.bool(forKey: "didRegister") {
                if let navTabBar = storyboard?.instantiateViewController(withIdentifier: "navTabBar") as? UINavigationController {
                    appDelegate.window?.rootViewController = navTabBar
                }
            } else {
                if let signup = storyboard?.instantiateViewController(withIdentifier: StoryboardIds.SingupViewController) as? SingupViewController {
                    appDelegate.window?.rootViewController = signup
                }
//                self.redirectToVC(storyboardId: StoryboardIds.SingupViewController, type: .Push)
            }
            
            let response = Services.init().getGlobalVariables()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                
            }
        }
    }

    @IBAction func buttonCloseTapped(_ sender: Any) {
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

enum ComingFrom: Int {
    case launch = 1
    case profile = 2
}

enum SelectedLanguage: Int {
    case arabic = 1
    case english = 2
}
