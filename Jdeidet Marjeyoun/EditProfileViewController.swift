//
//  EditProfileViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 10/2/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewUsername: UIView!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var viewFullName: UIView!
    @IBOutlet weak var textFieldFullName: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolBarView.labelTitle.text = NSLocalizedString("Edit Profile", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        self.popVC()
    }
    
    func initializeViews() {
        self.viewUsername.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewFullName.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewEmail.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewAddress.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
        self.viewPhoneNumber.addBottomBorderWithColor(color: Colors.lightGray, width: 1)
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
