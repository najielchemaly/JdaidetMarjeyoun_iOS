//
//  AboutViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/24/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import FSPagerView

class AboutViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewPager: FSPagerView!
    @IBOutlet weak var viewPageControl: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTitleTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
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
        
        self.labelTitleTopConstraint.constant = 0
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
