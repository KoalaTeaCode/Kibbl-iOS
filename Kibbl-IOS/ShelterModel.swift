//
//  ShelterModel.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/16/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import SwifterSwift

public class ShelterModel: Object, Mappable {
    dynamic var key: String? = nil
    dynamic var rescueGroupId: String? = nil
    dynamic var country: String? = nil
    dynamic var name: String? = nil
    dynamic var phone: String? = nil
    dynamic var state: String? = nil
    dynamic var email: String? = nil
    dynamic var city: String? = nil
    dynamic var zip: String? = nil
    dynamic var address1: String? = nil
//    dynamic var website: String? = nil
    dynamic var facebookUrl: String? = nil
    dynamic var facebookId: String? = nil
    dynamic var orgType: String? = nil
    dynamic var about: String? = nil
    dynamic var createdAt: String? = nil
    dynamic var following: Bool = false
    dynamic var imageURL1: String? = nil
    let connectedUpdated = LinkingObjects(fromType: UpdatesModel.self, property: "shelter")
    
    // Location Object
//    dynamic var place: String? = nil
    
    override public static func primaryKey() -> String? {
        return "key"
    }
    
    //Impl. of Mappable protocol
    required convenience public init?(map: Map) {
        self.init()
    }
    
    // Mappable
    public func mapping(map: Map) {
        if map.mappingType == .toJSON {
            var key = self.key
            key <- map["_id"]
        }
        else {
            key <- map["_id"]
        }
        rescueGroupId <- map["rescueGroupId"]
        country <- map["country"]
        name <- map["name"]
        phone <- map["phone"]
        state <- map["state"]
        email <- map["email"]
        city <- map["city"]
        zip <- map["zip"]
        address1 <- map["address1"]
//        website <- map["website"]
        facebookUrl <- map["facebookUrl"]
        orgType <- map["orgType"]
        about <- map["about"]
        createdAt <- map["createdAt"]
        imageURL1 <- map["facebook.cover"]
        facebookId <- map["facebook.id"]
//        subscribed <- map["active"]
    }
    
    // Mark: Getters
    
    func getName() -> String? {
        return self.name
    }
    
    func getDescription() -> String? {
        return self.about?.trimmed
    }
    
    func getCityState() -> String {
        var seperator = ""
        
        if self.state != nil {
            seperator = ", "
        }
        
        let cityState = (self.city ?? "") + seperator + (self.state ?? "")
        
        return cityState
    }
    
    class func getLatest(completionHandler: (Array<ShelterModel>) -> Void) {
        let realm = try! Realm()
        let objects = realm.objects(ShelterModel.self).filter("following == false").sorted(byKeyPath: "createdAt", ascending: false).get(offset: 0, limit: 3)
        completionHandler(objects as! Array<ShelterModel>)
    }
    
    func getWebsite() -> URL? {
        guard let id = self.facebookId, self.facebookId != "" else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.noWebsite)
            return nil
        }
        let urlString = "https://www.facebook.com/" + String(id)
        guard let url = URL(string: urlString) else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.noWebsite)
            return nil
        }
        return url
    }
}

extension ShelterModel {
    func save() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    class func all() -> Results<ShelterModel> {
        let realm = try! Realm()
        return realm.objects(ShelterModel.self)
    }
    
    class func allFollowing() -> Results<ShelterModel> {
        let realm = try! Realm()
        return realm.objects(ShelterModel.self).filter("following = true")
    }
    
    func updateName(name: String) {
        let realm = try! Realm()
        try! realm.write {
            self.name = name
        }
    }
    
    func update(following: Bool) {
        let realm = try! Realm()
        try! realm.write {
            self.following = following
        }
    }
    
    //@TODO: Probably not use update from at all
    func updateFrom(item: EventModel) {
        guard self.name == item.name else { return }
        let realm = try! Realm()
        try! realm.write {
            realm.add(item, update: true)
        }
    }
    
    func delete() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    class func getAllWithFilters() -> Results<ShelterModel> {
        let all = ShelterModel.all()
        
        var predicates = [NSPredicate]()
//        let filters = FilterModel.getActiveFilterModels()
//        for item in filters {
//            guard item.category == "Shelter" else { continue }
//            guard item.filterValue! != "" else { continue }
//            
//            let predicate = NSPredicate(format: "%K = %@", item.attributeName!, item.filterValue!)
//            
//            predicates.append(predicate)
//        }
        
//        if let filterModel = FilterModel.getActiveStateFilter() {
//            let predicate = NSPredicate(format: "%K = %@", "state", filterModel.filterValue!)
//
//            predicates.append(predicate)
//        }
        
        let defaults = UserDefaults.standard
        
//        if let city = defaults.string(forKey: UserDefaultKeys.city) {
//            if city != "" {
//                let predicate = NSPredicate(format: "%K = %@", "city", city)
//                predicates.append(predicate)
//            }
//        }
        
        if let state = defaults.string(forKey: UserDefaultKeys.state) {
            if state != "" {
                if let abbreviation = States.getAbbreviationFrom(stateName: state) {
                    let predicate = NSPredicate(format: "%K = %@", "state", abbreviation)
                    predicates.append(predicate)
                }
            }
        }

        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        return all.filter(compoundPredicate)
    }
    
    func subscribeCall() {
        API.sharedInstance.subscribe(shelter: self)
    }
    
    func switchSubscribed() {
        let realm = try! Realm()
        try! realm.write {
            following = !following
        }
    }
}
