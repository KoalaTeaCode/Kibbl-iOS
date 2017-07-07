//
//  LocationModel.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/18/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import SwifterSwift

public class LocationModel: Object, Mappable {
    dynamic var key: String? = nil
    dynamic var name: String? = nil
    dynamic var city: String? = nil
    dynamic var country: String? = nil
    dynamic var state: String? = nil
    dynamic var street: String? = nil
    dynamic var zip: String? = nil
    
    override public static func primaryKey() -> String? {
        return "key"
    }
    
    //Impl. of Mappable protocol
    required convenience public init?(map: Map) {
        self.init()
    }
    
    // Mappable
    public func mapping(map: Map) {
        key <- map["id"]
        name <- map["name"]
        city <- map["location.city"]
        country <- map["location.country"]
        state <- map["location.state"]
        street <- map["location.street"]
        zip <- map["location.zip"]
    }
    
    // Mark: Getters
    
    func getName() -> String? {
        return self.name
    }
}

extension LocationModel {
    func save() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    class func all() -> Results<LocationModel> {
        let realm = try! Realm()
        return realm.objects(LocationModel.self)
    }
    
    func updateName(name: String) {
        let realm = try! Realm()
        try! realm.write {
            self.name = name
        }
    }
    
    //@TODO: Probably not use update from at all
    func updateFrom(item: LocationModel) {
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
}
