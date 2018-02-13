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
        if let estimatedHeight = notifications[indexPath.row].rowHeight {
            return tableRowHeight + (estimatedHeight < 30 ? 30 : estimatedHeight)
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as? NotificationTableViewCell {
            cell.selectionStyle = .none
            
            let notification = notifications[indexPath.row]
            cell.labelTitle.text = notification.title
            cell.labelDescription.text = notification.description
            
            var height: Int = 0
            if let titleHeight = notification.title?.height(width: cell.labelTitle.frame.size.width, font: cell.labelTitle.font!) {
                height += Int(titleHeight)
            }
            
            if let descriptionHeight = notification.description?.height(width: cell.labelDescription.frame.size.width, font: cell.labelDescription.font!) {
                height += Int(descriptionHeight)
            }
            
            let oldHeight = notifications[indexPath.row].rowHeight
            notifications[indexPath.row].rowHeight = CGFloat(height)
            if oldHeight != notifications[indexPath.row].rowHeight {
//                tableView.reloadRows(at: [indexPath], with: .none)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}
