//
//  CityModel.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/2/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import SwifterSwift
import SwiftyJSON

public class CityModel: Object, Mappable {
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
        name <- map["CityName"]
        abbreviation <- map["SubDiv"]
    }
    
    // Mark: Getters
    
    
}

extension CityModel {
    func save() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    class func all() -> Results<CityModel> {
        let realm = try! Realm()
        return realm.objects(CityModel.self)
    }
    
    func delete() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    class func createDefaults() {
        
        let realm = try! Realm()
        guard realm.objects(CityModel.self).isEmpty else { return }
        
        DispatchQueue.global(qos: .background).async {
            if let file = Bundle.main.path(forResource: "US-STATES", ofType: "json") {
                do {
                    let jsonData = try Data(contentsOf: URL(fileURLWithPath: file))
                    let json = JSON(data: jsonData)
                    
                    for item in json["US-STATES"].arrayValue {
                        let name = String(describing: item["CityName"])
                        guard name != "" else { continue }
                        let cityModel = CityModel(JSONString: "\(item)")
                        
                        cityModel?.key = name + String(describing: item["SubDiv"])
                        
                        cityModel?.save()
                    }
                } catch {
                    log.info("Error loading Filters")
                }
            }
        }
    }
}
