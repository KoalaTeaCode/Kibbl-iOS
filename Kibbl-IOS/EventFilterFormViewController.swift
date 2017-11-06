//
//  EvetnFilterFormViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/31/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka
import SwifterSwift
import GooglePlaces

enum UserDefaultKeys {
    static let filters = "filters"
    static let location = "location"
    static let city = "city"
    static let state = "state"
}

enum GooglePlacesKeys {
    static let state = "administrative_area_level_1"
    static let city = "locality"
}

enum FilterKeys {
    static let state = "state"
    static let city = "city"
    
    static let tag = "tag"
    static let lastItemDate = "lastItemDate"
}

enum tags {
    static let between = "Between"
    static let and = "And"
    static let state = "State"
    static let city = "City"
    static let location = "Location"
}

class EventFilterFormViewController: FormViewController {
    
    typealias model = FilterModel
    
    lazy var states: [StateModel] = {
        return Array(StateModel.all().sorted(byKeyPath: "name", ascending: true))
    }()
    
    lazy var allCities: [CityModel] = {
        return Array(CityModel.all().sorted(byKeyPath: "name", ascending: true))
    }()
    
    lazy var cities: [CityModel] = {
        //@TODO:  Filter by active filter
        
        return Array(CityModel.all().sorted(byKeyPath: "name", ascending: true))
    }()
    
    var activeStartDate: String?
    var activeEndDate: String?
    var activeState: String?
    
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
        
        if let state = FilterModel.getActiveStateFilter() {
            activeState = state.filterValue
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
        
//        let startRow: DateInlineRow! = self.form.rowBy(tag: tags.between)
//        startRow.value = Date()?.startOfDay
//        startRow.updateCell()
//        let endRow: DateInlineRow! = self.form.rowBy(tag: tags.and)
//        endRow.value = Date()?.endOfDay
//        endRow.updateCell()
//        let stateRow: PickerInlineRow<StateModel>! = self.form.rowBy(tag: tags.state)
//        stateRow.value = stateRow.options[0]
//        stateRow.updateCell()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func rightNavButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func initializeForm() {
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
//                if activeLocation {
//                  $0.value = activeLocation
//                }
            }.onCellSelection({ (cell, row) in
                let autocompleteController = GMSAutocompleteViewController()
                autocompleteController.delegate = self
                self.present(autocompleteController, animated: true, completion: nil)
            })
    }
}

// Handle the user's selection.
extension EventFilterFormViewController: GMSAutocompleteViewControllerDelegate {
    
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
