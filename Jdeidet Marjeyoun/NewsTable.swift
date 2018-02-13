//
//  NewsTable.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/16/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class NewsTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var news: [News] = [News]()
    
    func setupContent() {
        self.register(UINib.init(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        
        self.tableFooterView = UIView()
        
        self.delegate = self
        self.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell {
            
            let new = news[indexPath.row]
            if let image = new.images?.first {
                cell.imageViewThumb.kf.setImage(with: URL(string: Services.getMediaUrl() + image))
            }
            cell.labelTitle.text = new.title
            cell.labelDescription.text = new.shortDescription
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DatabaseObjects.selectedNews = news[indexPath.row]
        
        currentVC.redirectToVC(storyboardId: StoryboardIds.NewsDetailsViewController, type: .Push)
    }
    
}
