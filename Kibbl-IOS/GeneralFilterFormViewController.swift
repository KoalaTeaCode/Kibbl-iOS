//
//  GeneralFilterFormViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 9/7/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka
import SwifterSwift
import GooglePlaces

enum FormType {
    case events
    case shelters
    case pets
}

class GeneralFilterFormViewController: FormViewController {
    
    typealias model = FilterModel
    
    var activeStartDate: String?
    var activeEndDate: String?
    var activeLocation: String?
    var formType = FormType.pets
    
    init(formType: FormType) {
        super.init(style: .grouped)
        self.formType = formType

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FilterModel.activeCountOf(category: "Events") != 0 {
            let filters = FilterModel.getActiveFilterModelsOf(category: "Events")
            for item in filters {
                switch item.attributeName! {
                case "startTimeDate":
                    activeStartDate = item.filterValue
                case "endTimeDate":
                    activeEndDate = item.filterValue
                case "locationCity":
                    log.info("city")
                default: // locationState
                    break
                }
            }
        }
        
        let defaults = UserDefaults.standard
        if let location = defaults.string(forKey: UserDefaultKeys.location) {
            self.activeLocation = location
        }
        
        self.initializeForm()
        
        setupNavBar()
    }
    
    func setupNavBar() {
        self.title = "Filters"
        
        let rigthBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.rightNavButtonPressed))
        self.navigationItem.rightBarButtonItem = rigthBarButton
        
        let leftBarButton = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(self.leftNavButtonPressed))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func leftNavButtonPressed() {
        FilterModel.clearAllActiveOf(type: "Events")
        
        let defaults = UserDefaults.standard
        defaults.set("", forKey: UserDefaultKeys.city)
        defaults.set("", forKey: UserDefaultKeys.state)
        defaults.set("", forKey: UserDefaultKeys.location)
        
        NotificationCenter.default.post(name: .filterChanged, object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func rightNavButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func initializeForm() {
        switch formType {
        case .pets:
            self.setupPetForm()
        case .shelters:
            self.setupShelterForm()
        case .events:
            self.setupEventForm()
        }
    }
    
    lazy var ageOptions: [FilterModel] = {
        return Array(FilterModel.all().filter("category = %@", "Pets").filter("subCategory = 'Age'"))
    }()
    
    private func setupPetForm() {
        DateInlineRow.defaultRowInitializer = { row in row.minimumDate = Date() }
        
        form +++ SelectableSection<ListCheckRow<FilterModel>>("Age", selectionType: .singleSelection(enableDeselection: false))
        
        for option in ageOptions {
            form.last! <<< ListCheckRow<FilterModel>{ listRow in
                listRow.title = option.name!
                listRow.selectableValue = option
                listRow.value = nil
                }
                .cellSetup { cell, row in
                    let item = row.selectableValue!
                    switch item.active {
                    case false:
                        cell.accessoryType = .none
                    default:
                        row.value = row.selectableValue
                        cell.accessoryType = .checkmark
                    }
            }
        }
        
        form +++ SelectableSection<ListCheckRow<FilterModel>>("Type", selectionType: .singleSelection(enableDeselection: false))
        
        let options1 = FilterModel.all().filter("category = %@", "Pets").filter("subCategory = 'Type'")
        for option in Array(options1) {
            form.last! <<< ListCheckRow<FilterModel>{ listRow in
                listRow.title = option.name!
                listRow.selectableValue = option
                listRow.value = nil
                }
                .cellSetup { cell, row in
                    let item = row.selectableValue!
                    switch item.active {
                    case false:
                        cell.accessoryType = .none
                    default:
                        row.value = row.selectableValue
                        cell.accessoryType = .checkmark
                    }
            }
        }
        
        form +++ SelectableSection<ListCheckRow<FilterModel>>("Gender", selectionType: .singleSelection(enableDeselection: false))
        
        let options2 = FilterModel.all().filter("category = %@", "Pets").filter("subCategory = 'Gender'")
        for option in Array(options2) {
            form.last! <<< ListCheckRow<FilterModel>{ listRow in
                listRow.title = option.name!
                listRow.selectableValue = option
                listRow.value = nil
                }
                .cellSetup { cell, row in
                    let item = row.selectableValue!
                    switch item.active {
                    case false:
                        cell.accessoryType = .none
                    default:
                        row.value = row.selectableValue
                        cell.accessoryType = .checkmark
                    }
            }
        }
        form +++ Section("Location")
            <<< LabelRow(tags.location) {
                $0.title = $0.tag
                $0.value = ""
                if activeLocation != nil, activeLocation != "" {
                    $0.value = activeLocation
                }
                }.onCellSelection({ (cell, row) in
                    let autocompleteController = GMSAutocompleteViewController()
                    autocompleteController.delegate = self
                    self.present(autocompleteController, animated: true, completion: nil)
                })
    }
    
    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        guard formType == .pets else { return }
        if row.section === form[0] || row.section === form[1]  || row.section === form[2] {
            guard let item = row.baseValue else { return }
            let filter = item as! FilterModel
            filter.setActive()
        }
    }
    
    private func setupEventForm() {
        DateInlineRow.defaultRowInitializer = { row in row.minimumDate = Date() }
        
        form +++ Section("Date")
            <<< DateInlineRow(tags.between) {
                $0.title = $0.tag
                $0.value = Date()
                if activeStartDate != nil {
                    $0.value = Date(iso8601String: activeStartDate!)
                }
                
                }
                .onChange { [weak self] row in
                    let endRow: DateInlineRow! = self?.form.rowBy(tag: tags.and)
                    if row.value?.compare(endRow.value!) == .orderedDescending {
                        endRow.value = row.value
                        endRow.minimumDate = row.value
                        endRow.updateCell()
                    }
                    
                    let startObject = FilterModel.all().filter("name = %@", "Start").first!
                    let date = row.value!.startOfDay
                    startObject.update(filterValue: date.iso8601String)
                    startObject.update(active: true)
            }
            
            <<< DateInlineRow(tags.and){
                $0.title = $0.tag
                $0.value = Date()
                if activeEndDate != nil {
                    $0.value = Date(iso8601String: activeEndDate!)
                }
                }
                .onChange { [] row in
                    let startObject = FilterModel.all().filter("name = %@", "End").first!
                    let date = row.value!.endOfDay
                    startObject.update(filterValue: date.iso8601String)
                    startObject.update(active: true)
            }
            +++ Section("Location")
            <<< LabelRow(tags.location) {
                $0.title = $0.tag
                $0.value = ""
                if activeLocation != nil, activeLocation != "" {
                    $0.value = activeLocation
                }
                }.onCellSelection({ (cell, row) in
                    let autocompleteController = GMSAutocompleteViewController()
                    autocompleteController.delegate = self
                    self.present(autocompleteController, animated: true, completion: nil)
                })
    }
    
    private func setupShelterForm() {
        form +++ Section("Location")
            <<< LabelRow(tags.location) {
                $0.title = $0.tag
                $0.value = ""
                if activeLocation != nil, activeLocation != "" {
                    $0.value = activeLocation
                }
                }.onCellSelection({ (cell, row) in
                    let autocompleteController = GMSAutocompleteViewController()
                    autocompleteController.delegate = self
                    self.present(autocompleteController, animated: true, completion: nil)
                })
    }
}

// Handle the user's selection.
extension GeneralFilterFormViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //        print("Place name: \(place.name)")
        //        print("Place address: \(place.formattedAddress)")
        //        print("Place attributions: \(place.attributions)")
        
        
        // @TODO: Change to filters dictionary
        // Setting filters
        let defaults = UserDefaults.standard
        defaults.set(place.formattedAddress!,forKey: UserDefaultKeys.location)
        
        if let placeComponents = place.addressComponents {
            let tmpState = placeComponents.filter { $0.type == GooglePlacesKeys.state }.first
            if let state = tmpState {
                defaults.set(state.name,forKey: UserDefaultKeys.state)
            }
            
            let tmpCity = placeComponents.filter { $0.type == GooglePlacesKeys.city }.first
            if let city = tmpCity {
                defaults.set(city.name,forKey: UserDefaultKeys.city)
            }
        }
        
        let row = self.form.allSections.last!.first! as! LabelRow
        row.value = place.formattedAddress
        
        NotificationCenter.default.post(name: .filterChanged, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
