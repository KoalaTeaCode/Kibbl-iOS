//
//  EventModel.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/12/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import SwifterSwift

public class EventModel: Object, Mappable {
    dynamic var key: String? = nil
    dynamic var name: String? = nil
    dynamic var desc: String? = nil
    dynamic var coverURL: String? = nil
    dynamic var start_time: String? = nil
    dynamic lazy var startTimeDate: Date? = {
        if let startTime = self.start_time {
            let date = Date(iso8601String: startTime)
            return date
        }
        return nil
    }()
    dynamic var end_time: String? = nil
    dynamic lazy var endTimeDate: Date? = {
        if let endTime = self.end_time {
            let date = Date(iso8601String: endTime)
            return date
        }
        return nil
    }()
    dynamic var updatedAt: String? = nil
    dynamic var createdAt: String? = nil
    dynamic var shelterId: String? = nil
    dynamic var facebookId: String? = nil
    // Location Object
    dynamic var locationName: String? = nil
    dynamic var locationCity: String? = nil
    dynamic var locationCountry: String? = nil
    dynamic var locationState: String? = nil
    dynamic var locationStreet: String? = nil
    dynamic var locationZip: String? = nil
    dynamic var favorited: Bool = false
    dynamic var imageURL1: String? = nil
    
    let newEventForShelter = LinkingObjects(fromType: UpdatesModel.self, property: "newEvents")
    let updatedEventForShelter = LinkingObjects(fromType: UpdatesModel.self, property: "updatedEvents")

    
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
        desc <- map["description"]
        coverURL <- map["facebook.cover"]
        start_time <- map["start_time"]
        end_time <- map["end_time"]
        updatedAt <- map["updatedAt"]
        createdAt <- map["createdAt"]
        shelterId <- map["shelterId"]
        
        facebookId <- map["shelterId.facebook.id"]
        
        // Location Object
        locationName <- map["place.name"]
        locationCity <- map["place.location.city"]
        locationCountry <- map["place.location.country"]
        locationState <- map["place.location.state"]
        locationStreet <- map["place.location.street"]
        locationZip <- map["place.location.zip"]
        
        favorited <- map["active"]
        imageURL1 <- map["facebook.cover"]
    }
    
    // Mark: Getters
    
    func getName() -> String? {
        return self.name
    }
    
    func getDescription() -> String? {
        return self.desc?.trimmed
    }
    
    func getEventTimeMonthName() -> String {
        let startDate = Date(iso8601String: self.start_time!)
        let startMonth = startDate!.monthName(ofStyle: .threeLetters)
        return startMonth
    }
    
    func getEventTimeDay() -> String {
        let startDate = Date(iso8601String: self.start_time!)
        let startDay = String(describing: startDate!.day)
        return startDay
    }
    
    func getCityState() -> String {
        var seperator = ""
        
        if self.locationState != nil {
            seperator = ", "
        }
        
        let cityState = (self.locationCity ?? "") + seperator + (self.locationState ?? "")
        
        return cityState
    }
    
    func getStreet() -> String {
        var seperator = ""
        
        if self.locationState != nil {
            seperator = ", "
        }
        
        let street = (self.locationStreet ?? "") + seperator + (self.locationZip ?? "")
        
        return street
    }
    
    class func getLatest(completionHandler: (Array<EventModel>) -> Void) {
        let realm = try! Realm()
        let objects = realm.objects(EventModel.self).filter("favorited == false").sorted(byKeyPath: "updatedAt", ascending: true).get(offset: 0, limit: 3)
        completionHandler(objects as! Array<EventModel>)
    }
    
    func getWebsite() -> URL? {
        guard let id = self.facebookId, self.facebookId != "" else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.noWebsite)
            return nil
        }
        let urlString = "https://www.facebook.com/" + id
        guard let url = URL(string: urlString) else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.noWebsite)
            return nil
        }
        return url
    }
}

extension EventModel {
    func save() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    class func all() -> Results<EventModel> {
        let realm = try! Realm()
        return realm.objects(EventModel.self)
    }
    
    class func allFavorites() -> Results<EventModel> {
        let realm = try! Realm()
        return realm.objects(EventModel.self).filter("favorited = true")
    }
    
    func updateName(name: String) {
        let realm = try! Realm()
        try! realm.write {
            self.name = name
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
    
    class func getAllWithFilters() -> Results<EventModel> {
        let all = EventModel.all()
        
        var predicates = [NSPredicate]()
        let filters = FilterModel.getActiveFilterModels()
        for item in filters {
            //@TODO: Guard this
            guard item.category == "Events" else { continue }
            guard item.filterValue! != "" else { continue }
            
            switch item.subCategory! {
            case "Location":
                let predicate = NSPredicate(format: "%K = %@", item.attributeName!, item.filterValue!)

                predicates.append(predicate)
            default: // Date
                var op = ""
                switch item.attributeName! {
                case "endTimeDate":
                    op = "<="
                default: // start_time
                    op = ">="
                }
                
                guard let date = Date(iso8601String: item.filterValue!) else { continue }
                //@TODO: Guards
                let predicate = NSPredicate(format: "%K \(op) %@", item.attributeName!, date as NSDate)
                
                predicates.append(predicate)
            }
            
            
        }
        
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)

        return all.filter(compoundPredicate)
    }
    
    func switchFavorite() {
        API.sharedInstance.favorite(event: self)
        
        let realm = try! Realm()
        try! realm.write {
            favorited = !favorited
        }
    }
}
