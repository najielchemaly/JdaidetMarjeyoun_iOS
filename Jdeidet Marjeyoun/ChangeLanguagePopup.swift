//
//  ChangeLanguagePopup.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 10/29/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import Firebase

class ChangeLanguagePopup: UIView {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonArabic: UIButton!
    @IBOutlet weak var buttonEnglish: UIButton!
    
    @IBAction func buttonArabicTapped(sender: AnyObject) {
        if Localization.currentLanguage() == "en" {
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
            
            self.switchLanguage(language: "ar")
        } else {
            if let profileVC = currentVC as? ProfileViewController {
                profileVC.hidePopupView()
            }
        }
    }
    
    @IBAction func buttonEnglishTapped(sender: AnyObject) {
        if Localization.currentLanguage() == "ar" {
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
            
            self.switchLanguage(language: "en")
        } else {
            if let profileVC = currentVC as? ProfileViewController {
                profileVC.hidePopupView()
            }
        }
    }
    
    func switchLanguage(language: String) {
        Localization.setLanguageTo(language)
        
        currentVC.redirectToVC(storyboardId: StoryboardIds.NavigationTabBarController, type: .Present)
//        if let navTabBar = currentVC.storyboard?.instantiateViewController(withIdentifier: "navTabBar") as? UINavigationController {
//            appDelegate.window?.rootViewController = navTabBar
//        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
