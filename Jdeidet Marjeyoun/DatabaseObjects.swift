//
//  DatabaseObjects.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/16/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import Foundation

class DatabaseObjects {
    
    static var latestNews: [News] = [News]()
    static var events: [News] = [News]()
    static var notifications: [Notifications] = [Notifications]()
    static var socials: [Notifications] = [Notifications]()
    static var complaints: [Category] = [Category]()
    static var contactsCategory: [Category] = [Category]()
    static var contacts: [Contact] = [Contact]()
    static var places: [Places] = [Places]()
    static var user: Users = Users()
    
    static var selectedNews: News!
    static var selectedPlace: Places!
    
    static var years: NSMutableArray = getYears()
    
}
