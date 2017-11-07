//
//  ChangeLanguagePopup.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 10/29/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class ChangeLanguagePopup: UIView {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonArabic: UIButton!
    @IBOutlet weak var buttonEnglish: UIButton!
    
    @IBAction func buttonArabicTapped(sender: AnyObject) {
        self.switchLanguage(language: "ar")
    }
    
    @IBAction func buttonEnglishTapped(sender: AnyObject) {
        self.switchLanguage(language: "en")
    }
    
    func switchLanguage(language: String) {
        Localization.setLanguageTo(language)
        
        if let navTabBar = currentVC.storyboard?.instantiateViewController(withIdentifier: "navTabBar") as? UINavigationController {
            appDelegate.window?.rootViewController = navTabBar
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
