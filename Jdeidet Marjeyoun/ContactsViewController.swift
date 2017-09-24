//
//  ContactsViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/17/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class ContactsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var textFieldCategory: UITextField!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var pickerView: UIPickerView!
    var selectedCategoryId: String!
    var filteredContacts: [Contact] = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupPickerView()
        self.getContactsData()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.viewCategory.customizeBorder(color: Colors.appBlue)
        self.viewTitle.customizeBorder(color: Colors.appBlue)
        
        self.toolBarView.labelTitle.text = "الدليل"
        self.toolBarView.buttonBack.isHidden = true
        self.toolBarView.buttonMenu.isHidden = true
        
        self.textFieldTitle.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.textFieldCategory.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        
        self.textFieldCategory.inputAccessoryView = toolbar
    }
    
    func doneButtonTapped() {
        if DatabaseObjects.contactsCategory.count > 0 {
            let row = self.pickerView.selectedRow(inComponent: 0)
            let category = DatabaseObjects.contactsCategory[row]
            self.selectedCategoryId = category.type
            self.textFieldCategory.text = category.title
        }
        
        self.dismissKeyboard()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DatabaseObjects.contactsCategory.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DatabaseObjects.contactsCategory[row].title
    }
    
    func getContactsData() {
        // TODO DUMMY DATA
        DatabaseObjects.contacts = [
            Contact.init(fullName: "أبو رزق الياس يوسف", mobileNumber: "١٢٣٤٤٥٦٧", phoneNumber: "١٢٣٤٤٥٦٧"),
            Contact.init(fullName: "أبو أيوب روز سليم", mobileNumber: "١٢٣٤٤٥٦٧", phoneNumber: "١٢٣٤٤٥٦٧"),
            Contact.init(fullName: "ابو حمرا الياس كايدد", mobileNumber: "١٢٣٤٤٥٦٧", phoneNumber: "١٢٣٤٤٥٦٧"),
            Contact.init(fullName: "ابو خروب نوال عادل", mobileNumber: "١٢٣٤٤٥٦٧", phoneNumber: "١٢٣٤٤٥٦٧"),
            Contact.init(fullName: "ابو خليل اندرية اميل", mobileNumber: "١٢٣٤٤٥٦٧", phoneNumber: "١٢٣٤٤٥٦٧"),
            Contact.init(fullName: "ابو خليل ألبير إميل", mobileNumber: "١٢٣٤٤٥٦٧", phoneNumber: "١٢٣٤٤٥٦٧"),
            Contact.init(fullName: "ابو خليل ريموندا اندراوس", mobileNumber: "١٢٣٤٤٥٦٧", phoneNumber: "١٢٣٤٤٥٦٧"),
            Contact.init(fullName: "ابو خير جوزيف فرح", mobileNumber: "١٢٣٤٤٥٦٧", phoneNumber: "١٢٣٤٤٥٦٧")
        ]
        
        self.filteredContacts = DatabaseObjects.contacts
        
        self.tableView.reloadData()
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: "ContactsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactsHeaderTableViewCell")
        self.tableView.register(UINib.init(nibName: "ContactsTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactsTableViewCell")
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func buttonSearchTapped(_ sender: Any) {
        self.tableView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.filteredContacts.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsHeaderTableViewCell") as? ContactsHeaderTableViewCell {
                cell.selectionStyle = .none
                
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell") as? ContactsTableViewCell {
                cell.selectionStyle = .none
                
                let contact = self.filteredContacts[indexPath.row]
                cell.labelFullName.text = contact.fullName
                cell.labelPhoneNumber.text = contact.phoneNumber
                cell.labelMobileNumber.text = contact.mobileNumber
                
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        self.filteredContacts = DatabaseObjects.contacts
        if let title = textField.text {
            if !title.isEmpty {
                self.filteredContacts = self.filteredContacts.filter { ($0.fullName?.lowercased().contains(title.lowercased()))! }
            }
        }
        
        self.tableView.reloadData()
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
