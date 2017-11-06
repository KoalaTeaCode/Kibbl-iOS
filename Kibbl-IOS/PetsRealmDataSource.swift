//
//  PetsRealmDataSource.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 9/12/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

struct Pet: Mappable {
    var key: String?
    var name: String?
    var desc: String?
    var mediaURL: String?
    var lastUpdate: String?
    var updatedAt: String?
    var createdAt: String?
    var shelterId: String?
    var sex: String?
    var age: String?
    var status: String?
    var size: String?
    var animal: String?
    var breed1: String?
    var breed2: String?
    var breed3: String?
    var imageURL1: String?
    var imageURL2: String?
    var imageURL3: String?
    
    var thumbURL1: String?
    var thumbURL2: String?
    var thumbURL3: String?
    var favorited: Bool = false
    
    var websiteURL: String?
    var locationName: String?
    var state: String?
    var zipcode: String?
    var phoneNumber: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        key <- map["_id"]
        name <- map["name"]
        desc <- map["description"]
        lastUpdate <- map["lastUpdate"]
        updatedAt <- map["updatedAt"]
        createdAt <- map["createdAt"]
        shelterId <- map["shelterId"]
        sex <- map["sex"]
        age <- map["age"]
        status <- map["status"]
        size <- map["size"]
        animal <- map["animal"]
        breed1 <- map["breeds.0"]
        breed2 <- map["breeds.1"]
        breed3 <- map["breeds.2"]
        imageURL1 <- map["media.0.urlSecureFullsize"]
        imageURL2 <- map["media.1.urlSecureFullsize"]
        imageURL3 <- map["media.2.urlSecureFullsize"]
        thumbURL1 <- map["media.0.urlSecureThumbnail"]
        thumbURL2 <- map["media.1.urlSecureThumbnail"]
        thumbURL3 <- map["media.2.urlSecureThumbnail"]
        favorited <- map["active"]
        websiteURL <- map["contact.url"]
        locationName <- map["contact.name"]
        state <- map["contact.state"]
        zipcode <- map["contact.location"]
        phoneNumber <- map["contact.phone"]
    }
}

extension Pet: Equatable {
    static func ==(lhs: Pet, rhs: Pet) -> Bool {
        let areEqual = lhs.key == rhs.key &&
            lhs.name == rhs.name
        
        return areEqual
    }
}



public class RealmPet: Object, Mappable {
    dynamic var key: String? = nil
    dynamic var name: String? = nil
    dynamic var desc: String? = nil
    dynamic var mediaURL: String? = nil
    dynamic var lastUpdate: String? = nil
    dynamic var updatedAt: String? = nil
    dynamic var createdAt: String? = nil
    dynamic var shelterId: String? = nil
    dynamic var sex: String? = nil
    dynamic var age: String? = nil
    dynamic var status: String? = nil
    dynamic var size: String? = nil
    dynamic var animal: String? = nil
    dynamic var breed1: String? = nil
    dynamic var breed2: String? = nil
    dynamic var breed3: String? = nil
    dynamic var imageURL1: String? = nil
    dynamic var imageURL2: String? = nil
    dynamic var imageURL3: String? = nil
    
    dynamic var thumbURL1: String? = nil
    dynamic var thumbURL2: String? = nil
    dynamic var thumbURL3: String? = nil
    dynamic var favorited: Bool = false
    
    dynamic var websiteURL: String? = nil
    dynamic var locationName: String? = nil
    dynamic var state: String? = nil
    dynamic var zipcode: String? = nil
    dynamic var phoneNumber: String? = nil
    
//    dynamic var connectedShelter: ShelterModel! = nil

//    let newPetForShelter = LinkingObjects(fromType: UpdatesModel.self, property: "newPets")
//    let updatedPetForShelter = LinkingObjects(fromType: UpdatesModel.self, property: "updatedPets")
    
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
        name <- map["name"]
        desc <- map["description"]
        lastUpdate <- map["lastUpdate"]
        updatedAt <- map["updatedAt"]
        createdAt <- map["createdAt"]
        shelterId <- map["shelterId"]
        sex <- map["sex"]
        age <- map["age"]
        status <- map["status"]
        size <- map["size"]
        animal <- map["animal"]
        breed1 <- map["breeds.0"]
        breed2 <- map["breeds.1"]
        breed3 <- map["breeds.2"]
        imageURL1 <- map["media.0.urlSecureFullsize"]
        imageURL2 <- map["media.1.urlSecureFullsize"]
        imageURL3 <- map["media.2.urlSecureFullsize"]
        thumbURL1 <- map["media.0.urlSecureThumbnail"]
        thumbURL2 <- map["media.1.urlSecureThumbnail"]
        thumbURL3 <- map["media.2.urlSecureThumbnail"]
        favorited <- map["active"]
        websiteURL <- map["contact.url"]
        locationName <- map["contact.name"]
        state <- map["contact.state"]
        zipcode <- map["contact.location"]
        phoneNumber <- map["contact.phone"]
        
//        connectedShelter <- (map["shelterId"], SingleTransform<ShelterModel>())
    }
    
    // Mark: Getters
    
    func getName() -> String? {
        return self.name
    }
    
    func getDescription() -> String? {
        return self.desc?.trimmed
    }
    
    class func getLatest(completionHandler: (Array<PetModel>) -> Void) {
        let realm = try! Realm()
        let objects = realm.objects(PetModel.self).filter("favorited == false").sorted(byKeyPath: "lastUpdate", ascending: false).get(offset: 0, limit: 3)
        completionHandler(objects as! Array<PetModel>)
    }
    
    func getImageURLS() -> [String] {
        
        var urls = [String]()
        
        if let image = imageURL1 {
            urls.append(image)
        }
        
        if let image = imageURL2 {
            urls.append(image)
        }
        
        if let image = imageURL3 {
            urls.append(image)
        }
        
        return urls
    }
    
    func getWebsite() -> URL? {
        guard let urlString = self.websiteURL, self.websiteURL != "" else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.noWebsite)
            return nil
        }
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
//    convenience init(model: Pet) {
//        self.init()
//    }

    var entity: Pet {
        //@TODO: Guards
        let copy: RealmPet = RealmPet(value: self)
        let selfJSONString = copy.toJSONString()!
        return Pet(JSONString: selfJSONString)!
    }
}

class PetsRealmDataSource: DataSource {
    typealias T = Pet
    
    private let realm = try! Realm()
    
    func getAll() -> [T] {
        return realm.objects(RealmPet.self).map { $0.entity }
    }
    
    func getById(id: String) -> T? {
        return realm.objects(RealmPet.self).filter("key = %@", id).first?.entity
    }
    
    func insert(item: T) {
        let jsonString = item.toJSONString()!
        let object = RealmPet(JSONString: jsonString)!
        try! realm.write {
            guard self.getById(id: object.key!) == nil else {return }
            realm.add(object)
        }
    }
    
    func update(item: T) {
        
    }
    
    func clean() {
        try! realm.write {
            realm.delete(realm.objects(RealmPet.self))
        }
    }
    
    func deleteById(id: String) {
        let item = getById(id: id)
        try! realm.write {
            let jsonString = item!.toJSONString()!
            realm.delete(RealmPet(JSONString: jsonString)!)
        }
    }
}
