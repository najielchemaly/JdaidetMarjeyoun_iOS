//
//  AppDefaults.swift
//  Ste-Louise
//
//  Created by MR.CHEMALY on 7/22/17.
//  Copyright © 2017 WeDevApp. All rights reserved.
//

import UIKit

var currentVC: UIViewController!
var isUserLoggedIn: Bool = false

let GMS_APIKEY = "AIzaSyD11O_Yqj_IIFQC6Rq-55amKes1iGV4Doo"

struct Colors {
    
    static let lightBlue: UIColor = UIColor(hexString: "#BDE2F5")!
    static let blue: UIColor = UIColor(hexString: "#85A7CB")!
    static let text: UIColor = UIColor(hexString: "#000000")!
    static let lighText: UIColor = UIColor(hexString: "#686868")!
    static let appBlue: UIColor = UIColor(hexString: "#5676B3")!
    static let lightGray: UIColor = UIColor.lightGray.withAlphaComponent(0.8)
    
}

struct Fonts {
    
    static let textFont_Bold: UIFont = UIFont(name: "DIN Next LT Arabic Bold", size: 17)!
    static let textFont_Regular: UIFont = UIFont(name: "DIN Next LT Arabic Regular", size: 17)!
    static let textFont_Light: UIFont = UIFont(name: "DIN Next LT Arabic Light", size: 17)!
    
}

struct StoryboardIds {
    
    static let SelectLanguageViewController: String = "SelectLanguageViewController"
    static let SingupViewController: String = "SingupViewController"
    static let NavigationTabBarController: String = "navTabBar"
    static let NewsViewController: String = "NewsViewController"
    static let NewsDetailsViewController: String = "NewsDetailsViewController"
    static let NotificationsViewController: String = "NotificationsViewController"
    static let ComplaintViewController: String = "ComplaintViewController"
    static let ContactsViewController: String = "ContactsViewController"
    static let PlacesViewController: String = "PlacesViewController"
    static let PlacesDetailsViewController: String = "PlacesDetailsViewController"
    static let MapViewController: String = "MapViewController"
    static let FeesViewController: String = "FeesViewController"
    
}

enum Keys: String {
    
    case AccessToken = "TOKEN"
    case AppLanguage = "APP-LANGUAGE"
    case AppVersion = "APP-VERSION"
    case DeviceId = "ID"

}

enum SegueId: String {

    case None
    
    var identifier: String {
        return String(describing: self).lowercased()
    }

}

enum PickerView: Int {
    
    case Cycle = 1
    case Classe = 2
    case Year = 3
    
}

enum FileType: Int {
    
    case Unknown = -1
    case PDF = 1
    case DOCX = 2
    case DOC = 3
    
}

enum Language: Int {
    
    case Arabic = 1
    case English = 2
    
}

enum NewsType {
 
    case None
    case LatestNews
    case Events
    case Notifications
    case Socials
    
    var identifier: String {
        return String(describing: self).lowercased()
    }

}

func getYears() -> NSMutableArray {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    let strDate = formatter.string(from: Date.init())
    if let intDate = Int(strDate) {
        let yearsArray: NSMutableArray = NSMutableArray()
        for i in (1964..<intDate) {
            yearsArray.add(String(format: "%d", i))
        }
        
        return yearsArray
    }
    
    return NSMutableArray()
}
