//
//  PopupView.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/11/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class ChangePasswordPopup: UIView {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewConfirmPassword: UIView!
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.hidePopupView()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
