//
//  NotificationsTable.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/16/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class NotificationsTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let tableRowHeight: CGFloat = 30
    
    var notifications: [Notifications] = [Notifications]()
    
    func setupContent() {
        self.register(UINib.init(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        
        self.tableFooterView = UIView()
        
        self.delegate = self
        self.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let description = notifications[indexPath.row].description
        let label = UILabel()
        label.text = description
        label.frame.size = CGSize(width: self.frame.size.width, height: 0)
        label.numberOfLines = 5
        var estimatedHeight = label.intrinsicContentSize.height
        let title = notifications[indexPath.row].title
        label.text = title
        estimatedHeight += label.intrinsicContentSize.height
        return tableRowHeight + (estimatedHeight < 30 ? 30 : estimatedHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as? NotificationTableViewCell {
            
            let notification = notifications[indexPath.row]
            cell.labelTitle.text = notification.title
            cell.labelDescription.text = notification.description
            
            return cell
        }
        
        return UITableViewCell()
    }
}
