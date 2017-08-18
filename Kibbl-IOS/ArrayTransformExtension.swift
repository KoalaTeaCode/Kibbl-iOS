//
//  ArrayTransformExtension.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 8/8/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class ArrayTransform<T:RealmSwift.Object> : TransformType where T:Mappable {
    typealias Object = List<T>
    typealias JSON = Array<AnyObject>
    
    func transformFromJSON(_ value: Any?) -> List<T>? {
        let realmList = List<T>()
        
        if let jsonArray = value as? Array<Any> {
            for item in jsonArray {
                if let realmModel = Mapper<T>().map(JSONObject: item) {
                    realmList.append(realmModel)
                }
            }
        }
        
        return realmList
    }
    
    func transformToJSON(_ value: List<T>?) -> Array<AnyObject>? {
        
        guard let realmList = value, realmList.count > 0 else { return nil }
        
        var resultArray = Array<T>()
        
        for entry in realmList {
            resultArray.append(entry)
        }
        
        return resultArray
    }
}

class SingleTransform<T:RealmSwift.Object> : TransformType where T:Mappable {
    func transformFromJSON(_ value: Any?) -> T? {
        if let value = value as? NSDictionary {
            let jsonData = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted )
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            let object = T.init(JSONString: jsonString!)
            return object
        }
        return nil
    }
    
    func transformToJSON(_ value: T?) -> AnyObject? {
        return value
    }
}

class KeyArrayTransform<T:RealmSwift.Object> : TransformType where T:Mappable {
    typealias Object = List<T>
    typealias JSON = Array<AnyObject>
    
    func transformFromJSON(_ value: Any?) -> List<T>? {
        let realmList = List<T>()
        
        if let array = value as? NSDictionary {
            for i in array {
                let key = i.key
                let realm = try! Realm()
                let item = realm.object(ofType: T.self, forPrimaryKey: key)
                guard let existingObject = item else { continue }
                realmList.append(existingObject)
            }
        }
        
        return realmList
    }
    
    func transformToJSON(_ value: List<T>?) -> Array<AnyObject>? {
        log.info("here4")
        guard let realmList = value, realmList.count > 0 else { return nil }
        
        var resultArray = Array<T>()
        
        for entry in realmList {
            resultArray.append(entry)
        }
        
        return resultArray
    }
}


