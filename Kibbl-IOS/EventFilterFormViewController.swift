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

enum tags {
    static let between = "Between"
    static let and = "And"
    static let state = "State"
    static let city = "City"
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
                    activeState = item.filterValue
                }
            }
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
        
        let startRow: DateInlineRow! = self.form.rowBy(tag: tags.between)
        startRow.value = Date()?.startOfDay
        startRow.updateCell()
        let endRow: DateInlineRow! = self.form.rowBy(tag: tags.and)
        endRow.value = Date()?.endOfDay
        endRow.updateCell()
        let stateRow: PickerInlineRow<StateModel>! = self.form.rowBy(tag: tags.state)
        stateRow.value = stateRow.options[0]
        stateRow.updateCell()
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
            <<< PickerInlineRow<StateModel>(tags.state) { (row : PickerInlineRow<StateModel>) -> Void in
                row.title = row.tag
                row.displayValueFor = { (rowValue: StateModel?) in
                    return rowValue.map { $0.name! + " - " + $0.abbreviation! }
                }
                row.options = states
                row.value = row.options[0]
                
                if activeState != nil {
                    let activeModel = StateModel.all().filter("abbreviation = %@", activeState!).first!
                    let index = states.index(of: activeModel)
                    row.value = row.options[index!]
                }
                
                }
                .onChange { [] row in
                    // set active state model
                    let filterObject = FilterModel.all().filter("category = %@", "Events").filter("name = %@", "State").first!
                    filterObject.update(filterValue: row.value!.abbreviation!)
                    filterObject.update(active: true)
                    
                    // filter cities
//                    self.cities = self.allCities.filter{ $0.abbreviation == row.value?.abbreviation }
                    
                    // update cell
//                    let rowToUpdate: PickerInlineRow<CityModel>! = self.form.rowBy(tag: tags.city)
//                    rowToUpdate.options = self.cities
//                    //@TODO: Add some sort of loading view
//                    guard !self.cities.isEmpty else { return }
//                    rowToUpdate.value = rowToUpdate.options[0]
//                    rowToUpdate.updateCell()
                }
//            <<< PickerInlineRow<CityModel>(tags.city) { (row : PickerInlineRow<CityModel>) -> Void in
//                row.title = row.tag
//                row.displayValueFor = { (rowValue: CityModel?) in
//                    return rowValue.map { $0.name! }
//                }
//                row.options = cities
//                row.value = row.options[0]
        
                //@TODO: Add city filter in
//                let filterObject = FilterModel.all().filter("category = %@", "Events").filter("name = %@", "City").first!
//                filterObject.update(filterValue: row.value!.name!)
//                filterObject.update(active: true)
//                }
    }
}
