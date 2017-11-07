//
//  PlacesDetailsViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/17/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import FSPagerView

class PlacesDetailsViewController: BaseViewController, FSPagerViewDataSource, FSPagerViewDelegate {

    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var viewPageControl: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    var place: Places!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupPlaceDetails()
        self.setupPagerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonMapTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.MapViewController, type: .Push)
    }
    
    func setupPlaceDetails() {
        if let place = DatabaseObjects.selectedPlace {
            self.place = place
            self.labelTitle.text = place.title
            self.labelDescription.text = place.description
            self.toolBarView.labelTitle.text = NSLocalizedString("Places to Visit", comment: "")
        }
    }
    
    func setupPagerView() {
        self.pagerView.register(UINib.init(nibName: "HomePagerView", bundle: nil), forCellWithReuseIdentifier: "HomePagerView")
        
        self.pagerView.dataSource = self
        self.pagerView.delegate = self
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HomePagerView", at: index) as? HomePagerView {
            
            cell.pageControl.numberOfPages = self.place.images == nil ? 1 /* TODO 0 */ : (self.place.images?.count)!
            cell.pageControl.currentPage = index
            
            cell.imageViewThumb.image = UIImage.init(named: self.place.thumb!)
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
        
        if let images = self.place.images {
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
