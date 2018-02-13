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
    @IBOutlet weak var labelEmpty: UILabel!
    
    var newsType: String = NewsType.None.identifier
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        switch newsType {
        case NewsType.LatestNews.identifier:
            self.getLatestNewsData()
        case NewsType.Activities.identifier:
            self.getActivitiesData()
        default:
            break
        }
        
        self.setupTableView()
        
        self.labelEmpty.text = NSLocalizedString("Data Empty", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch newsType {
        case NewsType.LatestNews.identifier:
            self.toolBarView.labelTitle.text = NSLocalizedString("Latest News", comment: "")
        case NewsType.Activities.identifier:
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
        case NewsType.Activities.identifier:
            self.tableView.news = DatabaseObjects.events
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
        case NewsType.LatestNews.identifier:
            self.getLatestNewsData(isRefreshing: true)
        case NewsType.Activities.identifier:
            self.getActivitiesData(isRefreshing: true)
        default:
            break
        }
    }
    
    func getLatestNewsData(isRefreshing: Bool = false) {
        if !isRefreshing {
            self.showWaitOverlay(color: Colors.appBlue)
        }
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getNews(type: NewsType.LatestNews.identifier)
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let jsonArray = json["news"] as? [NSDictionary] {
                        DatabaseObjects.latestNews = [News]()
                        for json in jsonArray {
                            let news = News.init(dictionary: json)
                            DatabaseObjects.latestNews.append(news!)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.news = DatabaseObjects.latestNews
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
//                if let message = response?.message {
//                    DispatchQueue.main.async {
//                        self.showAlert(message: message, style: .alert)
//                    }
//                }
            }
            
            DispatchQueue.main.async {
                self.removeAllOverlays()
                self.refreshControl.endRefreshing()
                
                if DatabaseObjects.latestNews.count == 0 {
                    self.view.sendSubview(toBack: self.tableView)
                } else {
                    self.view.bringSubview(toFront: self.tableView)
                }
            }
        }
    }
    
    func getActivitiesData(isRefreshing: Bool = false) {
        if !isRefreshing {
            self.showWaitOverlay(color: Colors.appBlue)
        }
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getNews(type: NewsType.Activities.identifier)
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let jsonArray = json["news"] as? [NSDictionary] {
                        DatabaseObjects.events = [News]()
                        for json in jsonArray {
                            let event = News.init(dictionary: json)
                            DatabaseObjects.events.append(event!)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.news = DatabaseObjects.events
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
//                if let message = response?.message {
//                    DispatchQueue.main.async {
//                        self.showAlert(message: message, style: .alert)
//                    }
//                }
            }
            
            DispatchQueue.main.async {
                self.removeAllOverlays()
                self.refreshControl.endRefreshing()
                
                if DatabaseObjects.events.count == 0 {
                    self.view.sendSubview(toBack: self.tableView)
                } else {
                    self.view.bringSubview(toFront: self.tableView)
                }
            }
        }
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
