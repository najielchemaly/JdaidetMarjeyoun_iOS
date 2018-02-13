//
//  NotificationsViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/16/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {

    @IBOutlet weak var tableView: NotificationsTable!
    @IBOutlet weak var labelEmpty: UILabel!
    
    var newsType: String = NewsType.Notifications.identifier
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch newsType {
        case NewsType.Notifications.identifier:
            self.getNotificationsData()
        case NewsType.Socials.identifier:
            self.getSocialsData()
        default:
            break
        }
        
        self.setupTableView()
        
        self.labelEmpty.text = NSLocalizedString("Data Empty", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch newsType {
        case NewsType.Notifications.identifier:
            self.toolBarView.labelTitle.text = NSLocalizedString("Notifications", comment: "")
            self.toolBarView.buttonBack.isHidden = true
            self.toolBarView.buttonMenu.isHidden = true
        case NewsType.Socials.identifier:
            self.toolBarView.labelTitle.text = NSLocalizedString("Socials", comment: "")
            self.toolBarView.buttonBack.isHidden = false
            self.toolBarView.buttonMenu.isHidden = false
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView() {
        switch newsType {
        case NewsType.Notifications.identifier:
            self.tableView.notifications = DatabaseObjects.notifications
        case NewsType.Socials.identifier:
            self.tableView.notifications = DatabaseObjects.socials
        default:
            break
        }
        
        self.tableView.setupContent()
        
        self.refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
    }
    
    func handleRefresh() {
        switch newsType {
        case NewsType.Notifications.identifier:
            self.getNotificationsData(isRefreshing: true)
        case NewsType.Socials.identifier:
            self.getSocialsData(isRefreshing: true)
        default:
            break
        }
    }
    
    func getNotificationsData(isRefreshing: Bool = false) {
        if !isRefreshing {
            self.showWaitOverlay(color: Colors.appBlue)
        }
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getNotifications()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let jsonArray = json["notifications"] as? [NSDictionary] {
                        DatabaseObjects.notifications = [Notifications]()
                        for json in jsonArray {
                            let notification = Notifications.init(dictionary: json)
                            DatabaseObjects.notifications.append(notification!)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.notifications = DatabaseObjects.notifications
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                if let message = response?.message {
                    self.showAlert(message: message, style: .alert)
                }
            }
            
            DispatchQueue.main.async {
                self.removeAllOverlays()
                self.refreshControl.endRefreshing()
                
                if DatabaseObjects.notifications.count == 0 {
                    self.view.sendSubview(toBack: self.tableView)
                } else {
                    self.view.bringSubview(toFront: self.tableView)
                }
            }
        }
        
//        // TODO DUMMY DATA
//        DatabaseObjects.notifications = [Notifications]()
//        for i in 0...5 {
//            let notification = Notifications()
//            notification.id = i+1
//            notification.description = "This is a long description \n This is a long description \n This is a long description for Notification \(i+1)"
//
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            notification.date = formatter.string(from: Date())
//
//            DatabaseObjects.notifications.append(notification)
//        }
    }
    
    func getSocialsData(isRefreshing: Bool = false) {
        if !isRefreshing {
            self.showWaitOverlay(color: Colors.appBlue)
        }
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getSocialNews()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let jsonArray = json["socials"] as? [NSDictionary] {
                        DatabaseObjects.socials = [Notifications]()
                        for json in jsonArray {
                            let social = Notifications.init(dictionary: json)
                            DatabaseObjects.socials.append(social!)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.notifications = DatabaseObjects.socials
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                if let message = response?.message {
                    self.showAlert(message: message, style: .alert)
                }
            }
            
            DispatchQueue.main.async {
                self.removeAllOverlays()
                self.refreshControl.endRefreshing()
                
                if DatabaseObjects.socials.count == 0 {
                    self.view.sendSubview(toBack: self.tableView)
                } else {
                    self.view.bringSubview(toFront: self.tableView)
                }
            }
        }
        
//        DatabaseObjects.socials = [Notifications]()
//        for i in 0...5 {
//            let notification = Notifications()
//            notification.id = i+1
//            notification.title = "This is a title for Socials \(i+1)"
//            notification.description = "This is a long description \n This is a long description \n This is a long description for Socials \(i+1)"
//
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            notification.date = formatter.string(from: Date())
//
//            DatabaseObjects.socials.append(notification)
//        }
//
//        self.tableView.reloadData()
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
