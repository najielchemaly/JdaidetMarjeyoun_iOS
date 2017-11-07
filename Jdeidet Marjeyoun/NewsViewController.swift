//
//  NewsViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/16/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class NewsViewController: BaseViewController {

    @IBOutlet weak var tableView: NewsTable!
    
    var newsType: String = NewsType.None.identifier
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        switch newsType {
        case NewsType.LatestNews.identifier:
            self.getLatestNewsData()
        case NewsType.Events.identifier:
            self.getActivitiesData()
        default:
            break
        }
        
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch newsType {
        case NewsType.LatestNews.identifier:
            self.toolBarView.labelTitle.text = NSLocalizedString("Latest News", comment: "")
        case NewsType.Events.identifier:
            self.toolBarView.labelTitle.text = NSLocalizedString("Events", comment: "")
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
        case NewsType.LatestNews.identifier:
            self.tableView.news = DatabaseObjects.latestNews
        case NewsType.Events.identifier:
            self.tableView.news = DatabaseObjects.events
        default:
            break
        }
        
        self.tableView.setupContent()
    }
    
    func getLatestNewsData() {
        // DUMMY DATA
        DatabaseObjects.latestNews = [News]()
        for i in 0...5 {
            let news = News()
            news.id = i+1
            news.shortDescription = "This is short description for LatestNews \(i+1)"
            news.title = "This is a title for LatestNews \(i+1)"
            news.description = "This is a long description \n This is a long description \n This is a long description for LatestNews \(i+1)"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            news.date = formatter.string(from: Date())
            
            DatabaseObjects.latestNews.append(news)
        }
        
        self.tableView.reloadData()
    }
    
    func getActivitiesData() {
        // TODO DUMMY DATA
        DatabaseObjects.events = [News]()
        for i in 0...5 {
            let news = News()
            news.id = i+1
            news.shortDescription = "This is short description for Activities \(i+1)"
            news.title = "This is a title for Activities \(i+1)"
            news.description = "This is a long description \n This is a long description \n This is a long description for Activities \(i+1)"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            news.date = formatter.string(from: Date())
            
            DatabaseObjects.events.append(news)
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
