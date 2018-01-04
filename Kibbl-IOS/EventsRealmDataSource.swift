//
//  EventsRealmDataSource.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 9/13/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

struct Event: Mappable {
    var key: String?
    var name: String?
    var desc: String?
    var coverURL: String?
    var start_time: String?
    var startTimeDate: Date? {
        if let startTime = self.start_time {
            let date = Date(iso8601String: startTime)
            return date
        }
        return nil
    }
    var end_time: String?
    var endTimeDate: Date? {
        if let endTime = self.end_time {
            let date = Date(iso8601String: endTime)
            return date
        }
        return nil
    }
    var updatedAt: String?
    var createdAt: String?
    var shelterId: String?
    var facebookId: String?
    // Location Object
    var locationName: String?
    var locationCity: String?
    var locationCountry: String?
    var locationState: String?
    var locationStreet: String?
    var locationZip: String?
    var favorited: Bool = false
    var imageURL1: String?
    
    var connectedShelter: ShelterModel!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
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
        
        connectedShelter <- (map["shelterId"], SingleTransform<ShelterModel>())
    }
}

extension Event: Equatable {
    static func ==(lhs: Event, rhs: Event) -> Bool {
        let areEqual = lhs.key == rhs.key &&
            lhs.name == rhs.name
        
        return areEqual
    }
}



public class RealmEvent: Object, Mappable {
    dynamic var key: String? = nil
    dynamic var name: String? = nil
    dynamic var desc: String? = nil
    dynamic var coverURL: String? = nil
    dynamic var start_time: String? = nil
    var startTimeDate: Date? {
        if let startTime = self.start_time {
            let date = Date(iso8601String: startTime)
            return date
        }
        return nil
    }
    dynamic var end_time: String? = nil
    var endTimeDate: Date? {
        if let endTime = self.end_time {
            let date = Date(iso8601String: endTime)
            return date
        }
        return nil
    }
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
    
//    let newEventForShelter = LinkingObjects(fromType: UpdatesModel.self, property: "newEvents")
//    let updatedEventForShelter = LinkingObjects(fromType: UpdatesModel.self, property: "updatedEvents")
    
    dynamic var connectedShelter: ShelterModel! = nil
    
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
        
//        connectedShelter <- (map["shelterId"], SingleTransform<ShelterModel>())
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
    
    var entity: Event {
        //@TODO: Guards
        let copy: RealmEvent = RealmEvent(value: self)
        let selfJSONString = copy.toJSONString()!
        return Event(JSONString: selfJSONString)!
    }
}

class EventsRealmDataSource: DataSource {
    typealias T = Event
    typealias RealmType = RealmEvent
    
    private let realm = try! Realm()
    
    var limit = 20
    var offset = 0
    
    func getAll() -> [T] {
        return realm.objects(RealmType.self).map { $0.entity }
    }
    
    func getAll(at lastItemDate: String) -> [T] {
        //@TODO: Get with active filters
        if lastItemDate == "" {
            return realm.objects(RealmType.self).map { $0.entity }
        }
        
        let filterPredicate = self.getFilterPredicate()
        let predicate = NSPredicate(format: "start_time == %@",lastItemDate)
        
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [filterPredicate,predicate])
        let realmObjects = realm.objects(RealmType.self).filter(compoundPredicate).get(offset: offset, limit: 20) as! Array<RealmType>
        offset += 20
        return realmObjects.map { $0.entity }
    }
    
    func getFilterPredicate() -> NSCompoundPredicate {
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

        let defaults = UserDefaults.standard
        
        if let city = defaults.string(forKey: UserDefaultKeys.city) {
            if city != "" {
                let predicate = NSPredicate(format: "%K = %@", "locationCity", city)
                predicates.append(predicate)
            }
        }
        
        if let state = defaults.string(forKey: UserDefaultKeys.state) {
            if state != "" {
                if let abbreviation = States.getAbbreviationFrom(stateName: state) {
                    let predicate = NSPredicate(format: "%K = %@", "locationState", abbreviation)
                    predicates.append(predicate)
                }
            }
        }
        
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        return compoundPredicate
    }
    
    func getById(id: String) -> T? {
        return realm.objects(RealmType.self).filter("key = %@", id).first?.entity
    }
    
    func insert(item: T) {
        let jsonString = item.toJSONString()!
        let object = RealmType(JSONString: jsonString)!
        try! realm.write {
            guard self.getById(id: object.key!) == nil else {return }
            realm.add(object)
        }
    }
    
    func update(item: T) {
        
    }
    
    func clean() {
        try! realm.write {
            realm.delete(realm.objects(RealmType.self))
        }
    }
    
    func deleteById(id: String) {
        let item = getById(id: id)
        try! realm.write {
            let jsonString = item!.toJSONString()!
            realm.delete(RealmType(JSONString: jsonString)!)
        }
    }
}
