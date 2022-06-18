//
//  HomeViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/12/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import FSPagerView
import Kingfisher

class HomeViewController: BaseViewController, FSPagerViewDataSource, FSPagerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var viewPageControl: UIView!
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewCollection: UIView!
    
    let itemPadding = 20
    let itemSpacing = 10
    
    var options: [HomeOptions] = [
        HomeOptions.init(title: NSLocalizedString("Fees", comment: ""), image: #imageLiteral(resourceName: "fees")),
        HomeOptions.init(title: NSLocalizedString("Events", comment: ""), image: #imageLiteral(resourceName: "activities")),
        HomeOptions.init(title: NSLocalizedString("Latest News", comment: ""), image: #imageLiteral(resourceName: "news")),
        HomeOptions.init(title: NSLocalizedString("Socials", comment: ""), image: #imageLiteral(resourceName: "socials")),
        HomeOptions.init(title: NSLocalizedString("About Us", comment: ""), image: #imageLiteral(resourceName: "about")),
        HomeOptions.init(title: NSLocalizedString("Places to Visit", comment: ""), image: #imageLiteral(resourceName: "location"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupCollectionView()
        self.setupCollectViewLayout()
        self.setupPagerView()
        self.getGlobalVariables()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.setupPagerView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCollectionView() {
        self.collectionView.register(UINib.init(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.setGradientBackground(parentView: self.viewCollection)
        self.viewCollection.bringSubview(toFront: self.collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell {
            
            let option = options[indexPath.row]
            cell.imageView.image = option.image
            cell.labelTitle.text = option.title
            
            cell.layer.cornerRadius = 10.0
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.redirectToVC(storyboardId: StoryboardIds.FeesViewController, type: .Push, newsType: .Activities)
        case 1:
            self.redirectToVC(storyboardId: StoryboardIds.NewsViewController, type: .Push, newsType: .Activities)
        case 2:
            self.redirectToVC(storyboardId: StoryboardIds.NewsViewController, type: .Push, newsType: .LatestNews)
        case 3:
            self.redirectToVC(storyboardId: StoryboardIds.NotificationsViewController, type: .Push, newsType: .Socials)
        case 4:
            self.redirectToVC(storyboardId: StoryboardIds.AboutViewController, type: .Push)
        case 5:
            self.redirectToVC(storyboardId: StoryboardIds.PlacesViewController, type: .Push)
        default:
            break
        }
    }
    
    func setupCollectViewLayout() {
        if let flow = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
            let itemSpacing = flow.minimumInteritemSpacing
            let width = self.view.bounds.size.width - CGFloat(6*itemSpacing)
            flow.itemSize = CGSize(width: width/3, height: width/3)
            flow.minimumLineSpacing = CGFloat(itemPadding)
            flow.minimumInteritemSpacing = CGFloat(itemPadding)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if let flow = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let totalCellHeight = flow.itemSize.height * CGFloat((options.count/3))
            let totalSpacingHeight = CGFloat(itemPadding * (options.count/3 + 1))
            
            let inset = ((collectionView.bounds.size.height - CGFloat(totalCellHeight + totalSpacingHeight)) / 2) + CGFloat((itemSpacing/3))
            
            let roundInset = roundf(Float(inset))
            
            return UIEdgeInsetsMake(CGFloat(roundInset), 0, CGFloat(roundInset), 0)
        }
        
        return collectionView.contentInset
    }
    
    func setupPagerView() {
        self.pagerView.register(UINib.init(nibName: "HomePagerView", bundle: nil), forCellWithReuseIdentifier: "HomePagerView")
        
        self.pagerView.dataSource = self
        self.pagerView.delegate = self
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HomePagerView", at: index) as? HomePagerView {
            
            cell.pageControl.numberOfPages = DatabaseObjects.highlightedNews.count
            cell.pageControl.currentPage = index
            
            let news = DatabaseObjects.highlightedNews[index]
            if let image = news.images?.first {
                cell.imageViewThumb.kf.setImage(with: URL.init(string: Services.getMediaUrl() + image))
            }
            
            cell.labelDescription.text = news.shortDescription
            
            return cell
        }
        
        return FSPagerViewCell()
    }
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {

    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let selectedNews = DatabaseObjects.highlightedNews[index]
        DatabaseObjects.selectedNews = selectedNews
        
        self.redirectToVC(storyboardId: StoryboardIds.NewsDetailsViewController, type: .Push)
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return DatabaseObjects.highlightedNews.count
    }
    
    func getGlobalVariables() {
        self.showWaitOverlay(color: Colors.appBlue)
        DispatchQueue.global(qos: .background).async {
            var response = Services.init().getGlobalVariables()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let mediaDefaultImage = json["mediaDefaultImage"] as? String {
                        DatabaseObjects.mediaDefaultImage = mediaDefaultImage
                    }
                    if let is_review = json["is_review"] as? Bool {
                        isReview = is_review
                    }
                    if let is_comingsoon = json["is_comingsoon"] as? Bool {
                        isComingSoon = is_comingsoon
                    }
                    if let mediaUrl = json["mediaUrl"] as? String {
                        Services.setMediaUrl(url: mediaUrl)
                    }
                    if let jsonArray = json["ComplaintsType"] as? [NSDictionary] {
                        DatabaseObjects.complaintsTypes = [ComplaintType]()
                        for json in jsonArray {
                            let complaintType = ComplaintType.init(dictionary: json)
                            DatabaseObjects.complaintsTypes.append(complaintType!)
                        }
                    }
                    if let jsonArray = json["PlaceCategories"] as? [NSDictionary] {
                        DatabaseObjects.placesCategories = [Category]()
                        DatabaseObjects.placesCategories.append(Category.init(name: NSLocalizedString("all", comment: ""), type: nil))
                        for json in jsonArray {
                            let placeCategory = Category.init(dictionary: json)
                            DatabaseObjects.placesCategories.append(placeCategory!)
                        }
                    }
                    if let jsonArray = json["DirectoryCategories"] as? [NSDictionary] {
                        DatabaseObjects.directoryCategories = [Category]()
                        DatabaseObjects.directoryCategories.append(Category.init(title: NSLocalizedString("all", comment: ""), type: nil))
                        for json in jsonArray {
                            let directoryCategory = Category.init(dictionary: json)
                            DatabaseObjects.directoryCategories.append(directoryCategory!)
                        }
                    }
                }
            }
            
            response = Services.init().getHighlightedNews()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let jsonArray = json["news"] as? [NSDictionary] {
                        DatabaseObjects.highlightedNews = [News]()
                        for json in jsonArray {
                            let highlightedNews = News.init(dictionary: json)
                            DatabaseObjects.highlightedNews.append(highlightedNews!)
                        }
                        
                        DispatchQueue.main.async {
                            self.pagerView.reloadData()
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.removeAllOverlays()
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

class HomeOptions {
    
    var title: String!
    var image: UIImage!
    
    init(title: String, image: UIImage) {
        self.title = title
        self.image = image
    }
    
}
