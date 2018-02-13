//
//  NewsDetailsViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/16/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import FSPagerView

class NewsDetailsViewController: BaseViewController, FSPagerViewDataSource, FSPagerViewDelegate {

    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var viewPageControl: UIView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!

    var news = News()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupNewsDetails()
        self.setupPagerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNewsDetails() {
        if let news = DatabaseObjects.selectedNews {
            self.news = news
            self.labelTitle.text = news.title
            self.labelDate.text = news.date
            self.labelDescription.text = news.description
            self.toolBarView.labelTitle.text = news.title
        }
    }
    
    func setupPagerView() {
        self.pagerView.register(UINib.init(nibName: "HomePagerView", bundle: nil), forCellWithReuseIdentifier: "HomePagerView")
        
        self.pagerView.dataSource = self
        self.pagerView.delegate = self
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HomePagerView", at: index) as? HomePagerView {
            
            cell.pageControl.currentPage = index
            cell.pageControl.numberOfPages = self.news.images == nil ? 0 : (self.news.images?.count)!
            
            if let images = self.news.images {
                cell.imageViewThumb.kf.setImage(with: URL(string: Services.getMediaUrl() + images[index]))
            }
            
            cell.labelDescription.isHidden = true
            
            return cell
        }
        
        return FSPagerViewCell()
    }
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        if let images = self.news.images {
            return images.count
        }
        
//        return 0
        
        // TODO
        return 1
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
