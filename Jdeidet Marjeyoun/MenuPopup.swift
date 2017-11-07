//
//  PopupView.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/11/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class MenuPopup: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    let rowHeight: CGFloat = 50

    let menuArray: [String] = [
        NSLocalizedString("Home", comment: ""),
        NSLocalizedString("Latest News", comment: ""),
        NSLocalizedString("Events", comment: ""),
        NSLocalizedString("Fees", comment: ""),
        NSLocalizedString("Places to Visit", comment: ""),
        NSLocalizedString("About Us", comment: ""),
        NSLocalizedString("Socials", comment: "")
    ]
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let baseVC = currentVC as? BaseViewController {
            baseVC.hidePopupView()
            baseVC.toolBarView.buttonMenu.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        }
        
        switch indexPath.row {
        case 0:
            currentVC.popVC(toRoot: true)
        case 1:
            if let newsVC = currentVC as? NewsViewController {
                if newsVC.newsType == NewsType.LatestNews.identifier {
                    return
                }
            }
            
            currentVC.redirectToVC(storyboardId: StoryboardIds.NewsViewController, type: .Push, newsType: .LatestNews)
        case 2:
            if let newsVC = currentVC as? NewsViewController {
                if newsVC.newsType == NewsType.Events.identifier {
                    return
                }
            }
            
            currentVC.redirectToVC(storyboardId: StoryboardIds.NewsViewController, type: .Push, newsType: .Events)
        case 3:
            if currentVC is FeesViewController {
                return
            }
            
            currentVC.redirectToVC(storyboardId: StoryboardIds.FeesViewController, type: .Push)
        case 4:
            if currentVC is PlacesViewController {
                return
            }
            
            currentVC.redirectToVC(storyboardId: StoryboardIds.PlacesViewController, type: .Push)
        case 5:
            if currentVC is AboutViewController {
                return
            }
            
            currentVC.redirectToVC(storyboardId: StoryboardIds.AboutViewController, type: .Push)
        case 6:
            if let newsVC = currentVC as? NotificationsViewController {
                if newsVC.newsType == NewsType.Socials.identifier {
                    return
                }
            }
            
            currentVC.redirectToVC(storyboardId: StoryboardIds.NotificationsViewController, type: .Push, newsType: .Socials)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.textAlignment = .right
        cell.textLabel?.font = Fonts.textFont_Regular
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = menuArray[indexPath.row]
        cell.backgroundColor = Colors.appBlue
        
        return cell
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
