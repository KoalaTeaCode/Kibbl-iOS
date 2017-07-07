//
//  StateModel.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/31/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import SwifterSwift
import SwiftyJSON

public class StateModel: Object, Mappable {
    dynamic var key: String? = nil
    dynamic var name: String? = nil
    dynamic var abbreviation: String? = nil
    
    override public static func primaryKey() -> String? {
        return "key"
    }
    
    //Impl. of Mappable protocol
    required convenience public init?(map: Map) {
        self.init()
    }
    
    // Mappable
    public func mapping(map: Map) {
        key <- map["SubDiv"]
        name <- map["StateName"]
        abbreviation <- map["SubDiv"]
    }
    
    // Mark: Getters
    
    
}

extension StateModel {
    func save() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    class func all() -> Results<StateModel> {
        let realm = try! Realm()
        return realm.objects(StateModel.self)
    }
    
    func delete() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    class func createDefaults() {
//        let realm = try! Realm()
//        guard realm.objects(StateModel.self).isEmpty else { return }
        
//        DispatchQueue.global(qos: .background).async {
            // Create empty model
            let emptyModel = StateModel()
            emptyModel.key = "0"
            emptyModel.name = ""
            emptyModel.abbreviation = ""
            emptyModel.save()
            
            if let file = Bundle.main.path(forResource: "US-STATES", ofType: "json") {
                do {
                    let jsonData = try Data(contentsOf: URL(fileURLWithPath: file))
                    let json = JSON(data: jsonData)
                    
                    for item in json["US-STATES"].arrayValue {
                        let abbreviation = String(describing: item["SubDiv"])
                        guard abbreviation != "" else { continue }
                        guard StateModel.all().filter("abbreviation = %@", abbreviation).first == nil else { continue }
                        let stateModel = StateModel(JSONString: "\(item)")
                        
                        stateModel?.save()
                    }
                } catch {
                    log.info("Error loading Filters")
                }
            }
//        }
    }
}
