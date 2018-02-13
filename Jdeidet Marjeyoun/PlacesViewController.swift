//
//  PlacesViewController.swift
//  Jdeidet Marjeyoun
//
//  Created by MR.CHEMALY on 9/17/17.
//  Copyright © 2017 marjeyoun-municipality. All rights reserved.
//

import UIKit

class PlacesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldCategory: UITextField!
    
    var pickerView: UIPickerView!
    var filteredPlaces: [Places] = [Places]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupPickerView()
        self.setupTableView()
        self.getPlacesToVisit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initializeViews() {
        self.viewCategory.customizeBorder(color: Colors.appBlue)
        self.viewTitle.customizeBorder(color: Colors.appBlue)
        
        self.toolBarView.labelTitle.text = NSLocalizedString("Places to Visit", comment: "")
        
        self.textFieldTitle.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.textFieldCategory.inputView = self.pickerView

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [doneButton, flexibleSpace, cancelButton]

        self.textFieldCategory.inputAccessoryView = toolbar
    }

    func doneButtonTapped() {
        if DatabaseObjects.placesCategories.count > 0 {
            let row = self.pickerView.selectedRow(inComponent: 0)
            let category = DatabaseObjects.placesCategories[row]
            self.textFieldCategory.text = category.name
        }

        self.dismissKeyboard()
    }
    
    func getPlacesToVisit() {
        DispatchQueue.global(qos: .background).async {
            let response = Services.init().getNews(type: NewsType.PlacesToVisit.identifier)
            if response?.status == ResponseStatus.SUCCESS.rawValue {
                if let json = response?.json?.first {
                    if let jsonArray = json["news"] as? [NSDictionary] {
                        DatabaseObjects.places = [Places]()
                        for json in jsonArray {
                            let place = Places.init(dictionary: json)
                            DatabaseObjects.places.append(place!)
                        }
                        
                        self.filteredPlaces = DatabaseObjects.places
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            
                            if self.filteredPlaces.count == 0 {
                                self.tableView.isHidden = true
                            } else {
                                self.tableView.isHidden = false
                            }
                        }
                    }
                }
            }
        }
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
            if let thumb = place.images?.first {
                cell.imageViewThumb.kf.setImage(with: URL(string: Services.getMediaUrl() + thumb))
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DatabaseObjects.selectedPlace = self.filteredPlaces[indexPath.row]
        
        self.redirectToVC(storyboardId: StoryboardIds.PlacesDetailsViewController, type: .Push)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DatabaseObjects.placesCategories.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DatabaseObjects.placesCategories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = DatabaseObjects.placesCategories[row]
        self.textFieldCategory.text = category.name
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        self.filterData()
    }
    
    @IBAction func buttonSearchTapped(_ sender: Any) {
        self.filterData()
    }
    
    func filterData() {
        self.filteredPlaces = DatabaseObjects.places
        if let title = textFieldTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if !title.isEmpty {
                self.filteredPlaces = self.filteredPlaces.filter { ($0.title?.lowercased().contains(title.lowercased()))! }
            }
        }
        if let category = textFieldCategory.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if !category.isEmpty && category.lowercased() != "all" {
                self.filteredPlaces = self.filteredPlaces.filter { ($0.category?.lowercased().contains(category.lowercased()))! }
            }
        }
        
        self.tableView.reloadData()
        
        if self.filteredPlaces.count == 0 {
            self.tableView.isHidden = true
        } else {
            self.tableView.isHidden = false
        }
    }
    
//    var errorMessage: String!
//    func isValidData() -> Bool {
//
//        if (textFieldCategory.text == nil || textFieldCategory.text == "") &&
//            (textFieldTitle.text == nil || textFieldTitle.text == "") {
//            errorMessage = NSLocalizedString("Category Place Empty", comment: "")
//            return false
//        }
//
//        return true
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
