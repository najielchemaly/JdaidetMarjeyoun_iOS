//
//  FeesViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/22/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class FeesViewController: BaseViewController, UIPickerViewDelegate {

    @IBOutlet weak var viewSection: UIView!
    @IBOutlet weak var viewBlock: UIView!
    @IBOutlet weak var viewYear: UIView!
    @IBOutlet weak var textFieldBlock: PSTextField!
    @IBOutlet weak var textFieldSection: PSTextField!
    @IBOutlet weak var textFieldYear: PSTextField!
    
    var pickerView: UIPickerView!
    var years: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupPickerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.viewSection.customizeBorder(color: Colors.appBlue)
        self.viewBlock.customizeBorder(color: Colors.appBlue)
        self.viewYear.customizeBorder(color: Colors.appBlue)
        
        self.toolBarView.labelTitle.text = NSLocalizedString("Fees", comment: "")
        
        self.years = DatabaseObjects.years
    }
    
    func setupPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.textFieldYear.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        
        self.textFieldYear.inputAccessoryView = toolbar
    }
    
    func doneButtonTapped() {
        if self.years.count > 0 {
            let row = self.pickerView.selectedRow(inComponent: 0)
            if let year = self.years[row] as? String {
                self.textFieldYear.text = year
            }
        }
        
        self.dismissKeyboard()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let year = String(describing: self.years[row])
        return year
    }

    @IBAction func buttonSearchTapped(_ sender: Any) {
        self.showPopupView(name: "FeesPopup")
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
