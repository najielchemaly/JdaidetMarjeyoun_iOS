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
    @IBOutlet weak var directoryTableView: UITableView!
    @IBOutlet weak var linksTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var pickerView: UIPickerView!
    var selectedCategoryId: String!
    var filteredContacts: [Contact] = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupPickerView()
        self.getContactsData()
        self.getUsefulLinksData()
        self.setupLinksTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            self.linksTableView.isHidden = false
        } else if segmentControl.selectedSegmentIndex == 1 {
            self.linksTableView.isHidden = true
        }
    }
    
    func initializeViews() {
        self.viewCategory.customizeBorder(color: Colors.appBlue)
        self.viewTitle.customizeBorder(color: Colors.appBlue)
        
        self.toolBarView.labelTitle.text = NSLocalizedString("Directory", comment: "")
        self.toolBarView.buttonBack.isHidden = true
        self.toolBarView.buttonMenu.isHidden = true
        
        self.textFieldTitle.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.segmentControl.setTitle(NSLocalizedString("Useful Links", comment: ""), forSegmentAt: 0)
        self.segmentControl.setTitle(NSLocalizedString("Phone Numbers", comment: ""), forSegmentAt: 1)
        
        self.directoryTableView.tableFooterView = UIView()
        self.directoryTableView.isHidden = false
    }
    
    func setupPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.textFieldCategory.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [doneButton, flexibleSpace, cancelButton]
        
        self.textFieldCategory.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        if DatabaseObjects.directoryCategories.count > 0 {
            let row = self.pickerView.selectedRow(inComponent: 0)
            let category = DatabaseObjects.directoryCategories[row]
            self.selectedCategoryId = category.type
            self.textFieldCategory.text = category.title
        }
        
        self.dismissKeyboard()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DatabaseObjects.directoryCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DatabaseObjects.directoryCategories[row].title
    }
    
    func getContactsData() {
        self.showWaitOverlay(color: Colors.appBlue)
        DatabaseObjects.contacts = [Contact]()
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getDirectory()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let jsonArray = json["directories"] as? [NSDictionary] {
                        for json in jsonArray {
                            let contact = Contact.init(dictionary: json)
                            DatabaseObjects.contacts.append(contact!)
                        }
                        
                        DispatchQueue.main.async {
                            self.filteredContacts = DatabaseObjects.contacts
                            self.setupDirectoryTableView()
                            self.filterData()
                        }
                    }
                }
            } else {
                if let message = response?.message {
                    self.showAlert(message: message, style: .alert)
                }
            }
            
            DispatchQueue.main.async {
                self.removeAllOverlays()
            }
        }
    }
    
    func getUsefulLinksData() {
        DatabaseObjects.usefulLinks = [UsefulLink]()
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getUsefullLinks()
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let jsonArray = json["links"] as? [NSDictionary] {
                        for json in jsonArray {
                            let usefulLink = UsefulLink.init(dictionary: json)
                            DatabaseObjects.usefulLinks.append(usefulLink!)
                        }
                        
                        DispatchQueue.main.async {
                            self.linksTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func setupDirectoryTableView() {
        self.directoryTableView.register(UINib.init(nibName: "ContactsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactsHeaderTableViewCell")
        self.directoryTableView.register(UINib.init(nibName: "ContactsTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactsTableViewCell")

        self.directoryTableView.delegate = self
        self.directoryTableView.dataSource = self
    }
    
    func setupLinksTableView() {
        self.linksTableView.register(UINib.init(nibName: "LinksTableViewCell", bundle: nil), forCellReuseIdentifier: "LinksTableViewCell")
        
        self.linksTableView.tableFooterView = UIView()
        
        self.linksTableView.delegate = self
        self.linksTableView.dataSource = self
    }
    
    @IBAction func buttonSearchTapped(_ sender: Any) {
        self.filterData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.linksTableView {
            return DatabaseObjects.usefulLinks.count
        }
        
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
        if tableView == self.linksTableView {
            return 1
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.linksTableView {
            return 50
        }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.linksTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LinksTableViewCell") as? LinksTableViewCell {
                
                cell.labelTitle.text = DatabaseObjects.usefulLinks[indexPath.row].title
                
                return cell
            }
            
            return UITableViewCell()
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.linksTableView {
            tableView.deselectRow(at: indexPath, animated: true)
            
            var urlString: String!
            if let url = DatabaseObjects.usefulLinks[indexPath.row].url {
                if !url.contains("http://") {
                    urlString = "http://" + url
                } else {
                    urlString = url
                }
            }
            
            guard let url = URL(string: urlString) else {
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.filterData()
    }
    
    func filterData() {
        self.filteredContacts = DatabaseObjects.contacts
        if let title = textFieldTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if !title.isEmpty {
                self.filteredContacts = self.filteredContacts.filter { ($0.fullName?.lowercased().contains(title.lowercased()))! }
            }
        }
        if let selectedCategory = textFieldCategory.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if !selectedCategory.isEmpty && selectedCategory.lowercased() != NSLocalizedString("all", comment: "") {
                self.filteredContacts = self.filteredContacts.filter { ($0.category?.lowercased().contains(selectedCategory.lowercased()))! }
            }
        }
        
        self.directoryTableView.reloadData()
        
        if self.filteredContacts.count == 0 {
            self.directoryTableView.isHidden = true
        } else {
            self.directoryTableView.isHidden = false
        }
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
