//
//  ListExtension.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/18/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

/// Maps object of Realm's List type
func <- <T: Mappable>(left: List<T>, right: Map)
{
    var array: [T]?
    
    if right.mappingType == .toJSON {
        array = Array(left)
    }
    
    array <- right
    
    if right.mappingType == .fromJSON {
        if let theArray = array {
            left.append(objectsIn: theArray)
        }
    }
}
