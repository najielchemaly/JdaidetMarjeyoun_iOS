//
//  HomeViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/12/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import FSPagerView

class HomeViewController: BaseViewController, FSPagerViewDataSource, FSPagerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var viewPageControl: UIView!
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewCollection: UIView!
    
    let itemPadding = 20
    let itemSpacing = 10
    
    var options: [HomeOptions] = [
        HomeOptions.init(title: "الرسوم البلدية ", image: #imageLiteral(resourceName: "fees")),
        HomeOptions.init(title: "النشاطات", image: #imageLiteral(resourceName: "activities")),
        HomeOptions.init(title: "آخر الاخبار", image: #imageLiteral(resourceName: "news")),
        HomeOptions.init(title: "اجتماعيات", image: #imageLiteral(resourceName: "socials")),
        HomeOptions.init(title: "عن البلدية", image: #imageLiteral(resourceName: "about")),
        HomeOptions.init(title: "اماكن للزيارة", image: #imageLiteral(resourceName: "location"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupCollectionView()
        self.setupCollectViewLayout()
        self.setupPagerView()
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
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.redirectToVC(storyboardId: StoryboardIds.FeesViewController, type: .Push, newsType: .Events)
        case 1:
            self.redirectToVC(storyboardId: StoryboardIds.NewsViewController, type: .Push, newsType: .Events)
        case 2:
            self.redirectToVC(storyboardId: StoryboardIds.NewsViewController, type: .Push, newsType: .LatestNews)
        case 3:
            self.redirectToVC(storyboardId: StoryboardIds.NotificationsViewController, type: .Push, newsType: .Socials)
        case 4:
            break
        case 5:
            self.redirectToVC(storyboardId: StoryboardIds.PlacesViewController, type: .Push)
        default:
            break
        }
    }
    
    func setupCollectViewLayout() {
        let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let itemSpacing = flow.minimumInteritemSpacing
        let width = self.view.bounds.size.width - CGFloat(6*itemSpacing)
        flow.itemSize = CGSize(width: width/3, height: width/3)
        flow.minimumLineSpacing = CGFloat(itemPadding)
        flow.minimumInteritemSpacing = CGFloat(itemPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let flow = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let totalCellHeight = flow.itemSize.height * CGFloat((options.count/3))
        let totalSpacingHeight = CGFloat(itemPadding * (options.count/3 + 1))
        
        let inset = ((collectionView.bounds.size.height - CGFloat(totalCellHeight + totalSpacingHeight)) / 2) + CGFloat((itemSpacing/3))
        
        let roundInset = roundf(Float(inset))
        
        return UIEdgeInsetsMake(CGFloat(roundInset), 0, CGFloat(roundInset), 0)
    }
    
    func setupPagerView() {
        self.pagerView.register(UINib.init(nibName: "HomePagerView", bundle: nil), forCellWithReuseIdentifier: "HomePagerView")
        
        self.pagerView.dataSource = self
        self.pagerView.delegate = self
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HomePagerView", at: index) as? HomePagerView {
            
            cell.pageControl.numberOfPages = 3
            cell.pageControl.currentPage = index
            
            cell.imageViewThumb.image = #imageLiteral(resourceName: "home_background")
            
            return cell
        }
        
        return FSPagerViewCell()
    }
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {

    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
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
