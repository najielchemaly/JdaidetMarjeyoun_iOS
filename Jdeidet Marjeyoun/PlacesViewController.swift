//
//  PlacesViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/17/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class PlacesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var textFieldCategory: UITextField!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var pickerView: UIPickerView!
    var selectedCategoryId: String!
    var filteredPlaces: [Places] = [Places]()
    
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
        
        self.toolBarView.labelTitle.text = "اماكن للزيارة"
        
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
        DatabaseObjects.places = [
            Places.init(title: "مطرانية الروم الكاثوليكة", description: "فوز فريق نادي شبيبة المرج على فريق القليعة بنتيجة 2/4 في دورة كرة القدم", location: "33.924906, 35.684201", thumb: "church1"),
            Places.init(title: "كنيسة الانجيلية", description: "فوز فريق نادي شبيبة المرج على فريق القليعة بنتيجة 2/4 في دورة كرة القدم", location: "33.926615, 35.680768", thumb: "church2")
        ]
        
        self.filteredPlaces = DatabaseObjects.places
        
        self.tableView.reloadData()
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: "PlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "PlacesTableViewCell")
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredPlaces.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesTableViewCell") as? PlacesTableViewCell {
            cell.selectionStyle = .none
            
            let place = self.filteredPlaces[indexPath.row]
            cell.labelTitle.text = place.title
            cell.imageViewThumb.image = UIImage.init(named: place.thumb!)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DatabaseObjects.selectedPlace = self.filteredPlaces[indexPath.row]
        
        self.redirectToVC(storyboardId: StoryboardIds.PlacesDetailsViewController, type: .Push)
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        self.filteredPlaces = DatabaseObjects.places
        if let title = textField.text {
            if !title.isEmpty {
                self.filteredPlaces = self.filteredPlaces.filter { ($0.title?.lowercased().contains(title.lowercased()))! }
            }
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func buttonSearchTapped(_ sender: Any) {
        self.tableView.isHidden = false
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
