//
//  UpdatesModel.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/22/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//


import UIKit
import RealmSwift
import ObjectMapper
import SwifterSwift

public class UpdatesModel: Object, Mappable {
    dynamic var key: String? = nil
    dynamic var checkDate: String? = nil
    var shelter = List<ShelterModel>()
    var newPets = List<PetModel>()
    var updatedPets = List<PetModel>()
    var newEvents = List<EventModel>()
    var updatedEvents = List<EventModel>()
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
        key <- map["_id"]
        checkDate <- map["checkDate"]
    }
    
    // Mark: Getters

    func getAllPetUpdates() -> [[PetModel]] {
        let newPets = Array(self.newPets)
        let updatePets = Array(self.updatedPets)
        return [newPets,updatePets]
    }
    func getAllEventsUpdates() -> [[EventModel]] {
        let newEvents = Array(self.newEvents)
        let updatedEvents = Array(self.updatedEvents)
        return [newEvents,updatedEvents]
    }

    func getFormattedTime() -> String {
        guard checkDate != nil else { return "" }
        let startDate = Date(iso8601String: self.checkDate!)
        let startDay = String(describing: startDate!.day)
        let startMonth = startDate!.monthName(ofStyle: .threeLetters)
        return startMonth + " " + startDay
    }
}

extension UpdatesModel {
    func save() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    class func all() -> Results<UpdatesModel> {
        let realm = try! Realm()
        return realm.objects(UpdatesModel.self)
    }
    
    class func allFollowing() -> Results<UpdatesModel> {
        let realm = try! Realm()
        return realm.objects(UpdatesModel.self).filter("following = true")
    }
    
    func delete() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    class func getAllWithFilters() -> Results<UpdatesModel> {
        let all = UpdatesModel.all()
        
        var predicates = [NSPredicate]()
        let filters = FilterModel.getActiveFilterModels()
        for item in filters {
            guard item.category == "Shelter" else { continue }
            guard item.filterValue! != "" else { continue }
            
            let predicate = NSPredicate(format: "%K = %@", item.attributeName!, item.filterValue!)
            
            predicates.append(predicate)
        }
        
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        
        return all.filter(compoundPredicate)
    }
    
    func addToNewPets(pet: PetModel) {
        let realm = try! Realm()
        try! realm.write {
            self.newPets.append(pet)
        }
    }
    
    func addToUpdatedPets(pet: PetModel) {
        let realm = try! Realm()
        try! realm.write {
            self.updatedPets.append(pet)
        }
    }
    
    func addToNewEvents(event: EventModel) {
        let realm = try! Realm()
        try! realm.write {
            self.newEvents.append(event)
        }
    }
    
    func addToUpdatedEvents(event: EventModel) {
        let realm = try! Realm()
        try! realm.write {
            self.updatedEvents.append(event)
        }
    }
}
