//
//  ShelterFilterViewController.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/31/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Eureka

class ShelterFilterFormViewController: FormViewController {
    
    typealias model = FilterModel
    
    lazy var states: [StateModel] = {
        return Array(StateModel.all().sorted(byKeyPath: "name", ascending: true))
    }()
    
    var activeState: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FilterModel.activeCountOf(category: "Shelter") != 0 {
            let filters = FilterModel.getActiveFilterModelsOf(category: "Shelter")
            for item in filters {
                switch item.attributeName! {
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
        FilterModel.clearAllActiveOf(type: "Shelter")
        
        let stateRow: PickerInlineRow<StateModel>! = self.form.rowBy(tag: tags.state)
        stateRow.value = stateRow.options[0]
        stateRow.updateCell()
    }
    
    func rightNavButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func initializeForm() {
        DateInlineRow.defaultRowInitializer = { row in row.minimumDate = Date() }
        
        form +++ Section("Location")
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
                    let filterObject = FilterModel.all().filter("category = %@", "Shelter").filter("name = %@", "State").first!
                    filterObject.update(filterValue: row.value!.abbreviation!)
                    filterObject.update(active: true)
        }
    }
}
