//
//  HomePagerView.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/12/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit
import FSPagerView

class HomePagerView: FSPagerViewCell {

    @IBOutlet weak var imageViewThumb: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
