//
//  FilterModel.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/26/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import SwifterSwift
import SwiftyJSON

public class FilterModel: Object, Mappable {
    dynamic var key: String? = nil
    dynamic var name: String? = nil
    dynamic var filterValue: String? = nil
    dynamic var attributeName: String? = nil
    dynamic var category: String? = nil
    dynamic var subCategory: String? = nil
    dynamic var active: Bool = false
    
    override public static func primaryKey() -> String? {
        return "key"
    }
    
    //Impl. of Mappable protocol
    required convenience public init?(map: Map) {
        self.init()
    }
    
    // Mappable
    public func mapping(map: Map) {
        key <- map["_id"]
        name <- map["name"]
        filterValue <- map["filterValue"]
        category <- map["category"]
        subCategory <- map["subCategory"]
        attributeName <- map["attributeName"]
    }
    
    // Mark: Getters
}

extension FilterModel {
    func save() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    class func isAnyActiveFilter() -> Bool {
        let all = FilterModel.all().filter("name != %@", "All").filter("active = %@", true)
        
        switch all.count {
        case 0:
            return false
        default:
            return true
        }
    }
    
    class func isAnyActiveFilter(type: String) -> Bool {
        let all = FilterModel.all().filter("name != %@", "All").filter("active = %@", true).filter("category = %@", type)
        
        switch all.count {
        case 0:
            return false
        default:
            return true
        }
    }
    
    class func all() -> Results<FilterModel> {
        let realm = try! Realm()
        return realm.objects(FilterModel.self)
    }
    
    func delete() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    class func createDefaultFilters() {
        let realm = try! Realm()
        guard realm.objects(FilterModel.self).isEmpty else {return}
        
        if let file = Bundle.main.path(forResource: "Filters", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: file))
                let json = try JSON(data: jsonData)
                
                for item in json["Filters"].arrayValue {
                    let newModel = FilterModel(JSONString: "\(item)")
                    
                    if newModel?.name == "All" {
                        newModel?.active = true
                    }
                    
                    newModel?.save()
                }
            } catch {
                log.info("Error loading Filters")
            }
        }

    }
    
    func update(filterValue: String) {
        let realm = try! Realm()
        try! realm.write {
            self.filterValue = filterValue
        }

        if filterValue == "" {
            self.update(active: false)
        }
        
        NotificationCenter.default.post(name: .filterChanged, object: nil)
    }
    
    func update(active: Bool) {
        let realm = try! Realm()
        try! realm.write {
            self.active = active
        }
        NotificationCenter.default.post(name: .filterChanged, object: nil)
    }
}

extension FilterModel {
    // Active
    
    class func getActiveFilterModels() -> [FilterModel] {
        let realm = try! Realm()
        return Array(realm.objects(FilterModel.self).filter("active = %@", true))
    }
    
    class func getActiveFilterModelsOf(category: String) -> [FilterModel] {
        let realm = try! Realm()
        return Array(realm.objects(FilterModel.self).filter("category = %@", category).filter("active = %@", true))
    }
    
    class func getActiveStateFilter() -> FilterModel? {
        return self.getActiveFilterModels().filter{ $0.name == "State" }.first
    }
    
    class func getStateFilterModel() -> FilterModel? {
        return self.all().filter{ $0.name == "State" }.first
    }
    
    class func getActiverCityFilter() -> FilterModel? {
        return self.getActiveFilterModels().filter{ $0.name == "City" }.first
    }
    
    class func getCityFilterModel() -> FilterModel? {
        return self.all().filter{ $0.name == "City" }.first
    }
    
    class func allActiveCount() -> Int {
        let all = FilterModel.all().filter("active = %@", true)
        return all.count
    }
    
    class func activeCountOf(category: String) -> Int {
        let all = FilterModel.all().filter("category = %@", category).filter("active = %@", true)
        return all.count
    }
    
    func activeCountFromSelfCategory() -> Int {
        let all = FilterModel.all().filter("subCategory = %@", self.subCategory!).filter("active = %@", true)
        return all.count
    }
    
    func switchActive() {
        let realm = try! Realm()
        try! realm.write {
            self.active = !self.active
        }
    }
    
    func setActive() {
        guard !self.active else { return }
        let all = FilterModel.all().filter("subCategory = %@", self.subCategory!)
        let allObject = all.filter("name = %@", "All").first
        
        let realm = try! Realm()
        for item in all {
            switch item == self {
            case true:
                self.switchActive()
                if self.activeCountFromSelfCategory() == 0 {
                    try! realm.write {
                        allObject?.active = true
                    }
                }
            default:
//                if item.name == "All" && self.activeCountFromSelfCategory() != 0 {
//                    try! realm.write {
//                        allObject?.active = false
//                    }
//                    continue
//                }
                
                // Set all other active items to false (single selection)
//                guard self.name == "All" else { continue }
                
                if item.active != false {
                    try! realm.write {
                        item.active = false
                    }
                }
            }
        }
        
        NotificationCenter.default.post(name: .filterChanged, object: nil)
    }
    
    class func clearAllActiveOf(type: String) {
        let all = FilterModel.all()
        for item in all {
            log.info(item.name)
            switch item.name! {
            case "All":
                log.debug("all")
                if item.active != true {
                    item.update(active: true)
                }
            default:
                log.info("here")
                if item.active != false {
                    item.update(active: false)
                }
            }
        }
        
        self.clearFilterKeys()
        
        NotificationCenter.default.post(name: .filterChanged, object: nil)
    }
    
    class func clearAllActive() {
        let all = FilterModel.all()
        let realm = try! Realm()
        for item in all {
            switch item.name! {
            case "All":
                if item.active != true {
                    try! realm.write {
                        item.active = true
                    }
                }
            default:
                if item.active != false {
                    try! realm.write {
                        item.active = false
                    }
                }
            }
        }
        
        self.clearFilterKeys()
        
        NotificationCenter.default.post(name: .filterChanged, object: nil)
    }
    
    class func clearFilterKeys() {
        // Delete filter keys
        let defaults = UserDefaults.standard
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
    
    class func getFiltersAsDictionary(modelType: ModelTypes) -> [String: String] {
        var params = [String: String]()
        
        switch modelType {
        case .pets:
            if FilterModel.allActiveCount() != 0 {
                for filter in FilterModel.getActiveFilterModelsOf(category: "Pets") {
                    guard filter.filterValue != "" else { continue }
                    
                    if filter.attributeName == "animal" {
                        params[API.Params.type] = filter.filterValue
                        continue
                    }
                    if filter.attributeName == "sex" {
                        params[API.Params.gender] = filter.filterValue
                        continue
                    }
                    
                    params[filter.attributeName!] = filter.filterValue
                }
                
                let defaults = UserDefaults.standard
                if let location = defaults.string(forKey: UserDefaultKeys.location) {
                    params[API.Params.location] = location
                }
            }
            break
        case .events:
            if FilterModel.allActiveCount() != 0 {
                params[API.Params.startDate] = Date().startOfDay.iso8601String
                
                for filter in FilterModel.getActiveFilterModelsOf(category: "Events") {
                    
                    if filter.attributeName == "startTimeDate" {
                        params[API.Params.startDate] = filter.filterValue
                        continue
                    }
                    if filter.attributeName == "endTimeDate" {
                        params[API.Params.endDate] = filter.filterValue
                        continue
                    }
                    
                    if filter.attributeName == "locationState" {
                        let stateModel = StateModel.all().filter("abbreviation = %@", filter.filterValue!).first!
                        params[API.Params.location] = stateModel.name
                        continue
                    }
                    
                    params[filter.attributeName!] = filter.filterValue
                }
                
                let defaults = UserDefaults.standard
                if let location = defaults.string(forKey: UserDefaultKeys.location) {
                    params[API.Params.location] = location
                }
            }

            break
        case .shelters:
            if FilterModel.allActiveCount() != 0 {
                for filter in FilterModel.getActiveFilterModelsOf(category: "Shelter") {
                    guard filter.filterValue != "" else { continue }
                    
                    params[filter.attributeName!] = filter.filterValue
                }
                
                let defaults = UserDefaults.standard
                if let location = defaults.string(forKey: UserDefaultKeys.location) {
                    params[API.Params.location] = location
                }
            }
            break
        }
        
        return params
    }
}
