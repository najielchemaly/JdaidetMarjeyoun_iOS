//
//  AboutViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/24/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import FSPagerView

class AboutViewController: BaseViewController, FSPagerViewDataSource, FSPagerViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewPager: FSPagerView!
    @IBOutlet weak var viewPageControl: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTitleTopConstraint: NSLayoutConstraint!
    
    var images: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupPagerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let width = self.view.frame.size.width
        let height = self.labelDescription.frame.origin.y+self.labelDescription.frame.size.height
        
        self.scrollView.contentSize = CGSize(width: width, height: height-self.viewPager.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initializeViews() {
        self.toolBarView.labelTitle.text = NSLocalizedString("About Us", comment: "")
        
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getAboutUs()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                DispatchQueue.main.async {
                    if let json = response?.json?.first {
                        if let title = json["title"] as? String {
                            self.labelTitle.text = title
                        }
                        if let description = json["description"] as? String {
                            self.labelDescription.text = description
                        }
                        if let images = json["images"] as? [String] {
                            self.images = [String]()
                            for image in images {
                                self.images.append(image)
                            }
                            
                            self.viewPager.reloadData()
                        }
                    }
                }
            }
        }
        
//        self.labelTitleTopConstraint.constant = 0
    }
    
    func setupPagerView() {
        self.viewPager.register(UINib.init(nibName: "HomePagerView", bundle: nil), forCellWithReuseIdentifier: "HomePagerView")
        
        self.viewPager.dataSource = self
        self.viewPager.delegate = self
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HomePagerView", at: index) as? HomePagerView {
            
            cell.pageControl.numberOfPages = self.images.count
            cell.pageControl.currentPage = index
            
            let image = self.images[index]
            cell.imageViewThumb.kf.setImage(with: URL.init(string: Services.getMediaUrl() + image))
            
            return cell
        }
        
        return FSPagerViewCell()
    }
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.images.count
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
