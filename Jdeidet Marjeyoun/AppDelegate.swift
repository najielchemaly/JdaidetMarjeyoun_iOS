//
//  AppDelegate.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/11/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    let gcmMessageIDKey: String = "message"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Localization.doTheExchange()
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        GMSServices.provideAPIKey(GMS_APIKEY)
//        GMSPlacesClient.provideAPIKey("AIzaSyD11O_Yqj_IIFQC6Rq-55amKes1iGV4Doo")
        
        let lang = Localization.currentLanguage()
        Localization.setLanguageTo(lang)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        if let data = UserDefaults.standard.data(forKey: "user"),
            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            if let navTabBar = storyboard.instantiateViewController(withIdentifier: "navTabBar") as? UINavigationController {
                DatabaseObjects.user = user
                self.window?.rootViewController = navTabBar
            }
        }
        
//        if UserDefaults.standard.bool(forKey: "didFinishLaunching") {
//            if let navTabBar = storyboard.instantiateViewController(withIdentifier: "navTabBar") as? UINavigationController {
//                application.keyWindow?.rootViewController = navTabBar
//            }
//        }
        
        return true
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        DatabaseObjects.FIREBASE_TOKEN = fcmToken
        
        if let deviceToken = fcmToken.data(using: .utf8) {
            Messaging.messaging().apnsToken = deviceToken
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        if let fcmToken = Messaging.messaging().fcmToken {
            DatabaseObjects.FIREBASE_TOKEN = fcmToken            
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        if let type = userInfo["type"] as? String, type == "latestnews" {
            if let newsVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.NewsViewController) as? NewsViewController, let baseVC = currentVC as? BaseViewController {
                newsVC.newsType = NewsType.LatestNews.identifier
                baseVC.navigationController?.pushViewController(newsVC, animated: true)
            }
        } else if let type = userInfo["type"] as? String, type == "activities" {
            if let newsVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.NewsViewController) as? NewsViewController, let baseVC = currentVC as? BaseViewController {
                newsVC.newsType = NewsType.Activities.identifier
                baseVC.navigationController?.pushViewController(newsVC, animated: true)
            }
        } else if let type = userInfo["type"] as? String, type == "sociallife" {
            if let notificationsVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.NotificationsViewController) as? NotificationsViewController, let baseVC = currentVC as? BaseViewController {
                notificationsVC.newsType = NewsType.Socials.identifier
                baseVC.navigationController?.pushViewController(notificationsVC, animated: true)
            }
        } else {
            if let notificationsVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.NotificationsViewController) as? NotificationsViewController, let baseVC = currentVC as? BaseViewController {
                notificationsVC.newsType = NewsType.Notifications.identifier
                baseVC.navigationController?.pushViewController(notificationsVC, animated: true)
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        if let type = userInfo["type"] as? String, type == "latestnews" {
            if let newsVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.NewsViewController) as? NewsViewController, let baseVC = currentVC as? BaseViewController {
                newsVC.newsType = NewsType.LatestNews.identifier
                baseVC.navigationController?.pushViewController(newsVC, animated: true)
            }
        } else if let type = userInfo["type"] as? String, type == "activities" {
            if let newsVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.NewsViewController) as? NewsViewController, let baseVC = currentVC as? BaseViewController {
                newsVC.newsType = NewsType.Activities.identifier
                baseVC.navigationController?.pushViewController(newsVC, animated: true)
            }
        } else if let type = userInfo["type"] as? String, type == "sociallife" {
            if let notificationsVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.NotificationsViewController) as? NotificationsViewController, let baseVC = currentVC as? BaseViewController {
                notificationsVC.newsType = NewsType.Socials.identifier
                baseVC.navigationController?.pushViewController(notificationsVC, animated: true)
            }
        } else {
            if let notificationsVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.NotificationsViewController) as? NotificationsViewController, let baseVC = currentVC as? BaseViewController {
                notificationsVC.newsType = NewsType.Notifications.identifier
                baseVC.navigationController?.pushViewController(notificationsVC, animated: true)
            }
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

