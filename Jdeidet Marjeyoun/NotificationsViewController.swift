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
    
    var newsType: String = NewsType.Notifications.identifier
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch newsType {
        case NewsType.Notifications.identifier:
            self.toolBarView.labelTitle.text = "اشعارات"
            self.toolBarView.buttonBack.isHidden = true
            self.toolBarView.buttonMenu.isHidden = true
        case NewsType.Socials.identifier:
            self.toolBarView.labelTitle.text = "اجتماعيات"
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
    }
    
    func getNotificationsData() {
        // TODO DUMMY DATA
        DatabaseObjects.notifications = [Notifications]()
        for i in 0...5 {
            let notification = Notifications()
            notification.id = i+1
            notification.description = "This is a long description \n This is a long description \n This is a long description for Notification \(i+1)"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            notification.date = formatter.string(from: Date())
            
            DatabaseObjects.notifications.append(notification)
        }
        
        self.tableView.reloadData()
    }
    
    func getSocialsData() {
        DatabaseObjects.socials = [Notifications]()
        for i in 0...5 {
            let notification = Notifications()
            notification.id = i+1
            notification.title = "This is a title for Socials \(i+1)"
            notification.description = "This is a long description \n This is a long description \n This is a long description for Socials \(i+1)"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            notification.date = formatter.string(from: Date())
            
            DatabaseObjects.socials.append(notification)
        }
        
        self.tableView.reloadData()
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
