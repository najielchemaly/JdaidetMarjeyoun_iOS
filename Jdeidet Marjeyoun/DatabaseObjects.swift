//
//  DatabaseObjects.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/16/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import Foundation

class DatabaseObjects {
    
    static var FIREBASE_TOKEN: String!
    
    static var highlightedNews: [News] = [News]()
    static var latestNews: [News] = [News]()
    static var events: [News] = [News]()
    static var notifications: [Notifications] = [Notifications]()
    static var socials: [Notifications] = [Notifications]()
    static var placesCategories: [Category] = [Category]()
    static var directoryCategories: [Category] = [Category]()
    static var contacts: [Contact] = [Contact]()
    static var places: [Places] = [Places]()
    static var complaintsTypes: [ComplaintType] = [ComplaintType]()
    static var usefulLinks: [UsefulLink] = [UsefulLink]()
    static var user: User = User()
    
    static var selectedNews: News!
    static var selectedPlace: Places!
    static var fees: Fees!
    static var mediaDefaultImage: String!
    
    static var years: NSMutableArray = getYears()
    
}
