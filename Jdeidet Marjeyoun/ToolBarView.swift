//
//  ToolBarView.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/16/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class ToolBarView: UIView {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var labelTitleCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonMenuCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBackCenterConstraint: NSLayoutConstraint!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        currentVC.popVC()
    }
    
    @IBAction func buttonMenuTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            if buttonMenu.imageView?.image == #imageLiteral(resourceName: "menu") {
                baseVC.showPopupView(name: "MenuPopup")
                buttonMenu.setImage(#imageLiteral(resourceName: "close"), for: .normal)
                buttonMenu.imageView?.contentMode = .scaleAspectFill
            } else {
                baseVC.hidePopupView()
                buttonMenu.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
                buttonMenu.imageView?.contentMode = .scaleAspectFill
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        if Localization.currentLanguage() == "ar" {
            self.buttonBack.setImage(#imageLiteral(resourceName: "backarrow_right"), for: .normal)
        } else {
            self.buttonBack.setImage(#imageLiteral(resourceName: "backarrow_left"), for: .normal)
        }
    }

}
