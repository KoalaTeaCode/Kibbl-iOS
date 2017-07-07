//
//  PetFilterFormViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/12/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka
import SwifterSwift

class PetFilterFormViewController: FormViewController {
    
    typealias model = FilterModel
    
    lazy var states: [StateModel] = {
        return Array(StateModel.all().sorted(byKeyPath: "name", ascending: true))
    }()
    
    lazy var ageOptions: [FilterModel] = {
        return Array(FilterModel.all().filter("category = %@", "Pets").filter("subCategory = 'Age'"))
    }()
    
    var activeState: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FilterModel.activeCountOf(category: "Pets") != 0 {
            let filters = FilterModel.getActiveFilterModelsOf(category: "Pets")
            for item in filters {
                
                if item.attributeName == "state" {
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
        FilterModel.clearAllActiveOf(type: "Pets")
        //@TODO: Reset Form
        self.dismiss(animated: true, completion: nil)
    }
    
    func rightNavButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func initializeForm() {
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
            <<< PickerInlineRow<StateModel>(tags.state) { (row : PickerInlineRow<StateModel>) -> Void in
                row.title = row.tag
                row.displayValueFor = { (rowValue: StateModel?) in
                    return rowValue.map { $0.name! + " - " + $0.abbreviation! }
                }
                row.options = states
                row.value = row.options[0]
                
                if activeState != nil {
                    guard let activeModel = StateModel.all().filter("abbreviation = %@", activeState!).first else { return }
                    let index = states.index(of: activeModel)
                    row.value = row.options[index!]
                }
                
                }
                .onChange { [] row in
                    // set active state model
                    let filterObject = FilterModel.all().filter("category = %@", "Pets").filter("name = %@", "State").first!
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
    
    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        
        if row.section === form[0] || row.section === form[1]  || row.section === form[2] {
            guard let item = row.baseValue else { return }
            let filter = item as! FilterModel
            filter.setActive()
        }
    }
}
