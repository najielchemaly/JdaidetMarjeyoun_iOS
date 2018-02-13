//
//  SelectLanguageViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/11/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import Firebase

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
        
        if let isLoggedIn = UserDefaults.standard.value(forKey: "isUserLoggedIn") as? Bool {
            isUserLoggedIn = isLoggedIn
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
                
                if #available(iOS 10.0, *) {
                    _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                        Messaging.messaging().unsubscribe(fromTopic: "/topics/jdeidetmarjeyounnewsen")
                        Messaging.messaging().subscribe(toTopic: "/topics/jdeidetmarjeyounnewsar")
                    })
                } else {
                    // Fallback on earlier versions
                    Messaging.messaging().unsubscribe(fromTopic: "/topics/jdeidetmarjeyounnewsen")
                    Messaging.messaging().subscribe(toTopic: "/topics/jdeidetmarjeyounnewsar")
                }
            } else {
                Localization.setLanguageTo("en")
                
                if #available(iOS 10.0, *) {
                    _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
                        Messaging.messaging().unsubscribe(fromTopic: "/topics/jdeidetmarjeyounnewsar")
                        Messaging.messaging().subscribe(toTopic: "/topics/jdeidetmarjeyounnewsen")
                    })
                } else {
                    // Fallback on earlier versions
                    Messaging.messaging().unsubscribe(fromTopic: "/topics/jdeidetmarjeyounnewsar")
                    Messaging.messaging().subscribe(toTopic: "/topics/jdeidetmarjeyounnewsen")
                }
            }
            
            if isUserLoggedIn {
                if let navTabBar = storyboard?.instantiateViewController(withIdentifier: "navTabBar") as? UINavigationController {
                    appDelegate.window?.rootViewController = navTabBar
                }
            } else {
                if let login = storyboard?.instantiateViewController(withIdentifier: StoryboardIds.LoginViewController) as? LoginViewController {
//                    signup.comingFrom = 1
                    appDelegate.window?.rootViewController = login
                }
//                self.redirectToVC(storyboardId: StoryboardIds.SingupViewController, type: .Push)
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
