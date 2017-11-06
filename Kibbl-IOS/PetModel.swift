//
//  PetModel.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/16/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import SwifterSwift

public class RealmString: Object {
    dynamic var stringValue = ""
}

public class PetModel: Object, Mappable {
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
    
    dynamic var connectedShelter: ShelterModel! = nil
    
    let newPetForShelter = LinkingObjects(fromType: UpdatesModel.self, property: "newPets")
    let updatedPetForShelter = LinkingObjects(fromType: UpdatesModel.self, property: "updatedPets")
    
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
        
        connectedShelter <- (map["shelterId"], SingleTransform<ShelterModel>())
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
    
//    
//    func getEventTimeMonthName() -> String {
//        let startDate = Date(iso8601String: self.start_time!)
//        let startMonth = startDate!.monthName(ofStyle: .threeLetters)
//        return startMonth
//    }
//    
//    func getEventTimeDay() -> String {
//        let startDate = Date(iso8601String: self.start_time!)
//        let startDay = String(describing: startDate!.day)
//        return startDay
//    }
}

extension PetModel {
    func save() {
        //@TODO: check if model exists before saving
        //Idk why update isn't working
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    class func all() -> Results<PetModel> {
        let realm = try! Realm()
        return realm.objects(PetModel.self)
    }
    
    class func allFavorites() -> Results<PetModel> {
        let realm = try! Realm()
        return realm.objects(PetModel.self).filter("favorited = true")
    }
    
    func updateName(name: String) {
        let realm = try! Realm()
        try! realm.write {
            self.name = name
        }
    }
    
    //@TODO: Probably not use update from at all
    func updateFrom(item: PetModel) {
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

    class func getAllWithFilters() -> Results<PetModel> {
        var all = PetModel.all()
        
        let filters = FilterModel.getActiveFilterModelsOf(category: "Pets")
        
        var typePred = [NSPredicate]()
        var agePred = [NSPredicate]()
        var genderPred = [NSPredicate]()
        
        for item in filters {
            guard item.category == "Pets" else { continue }
            guard item.filterValue! != "" else { continue }
            let predicate = NSPredicate(format: "%K = %@", item.attributeName!, item.filterValue!)

            switch item.subCategory! {
            case "Age":
                agePred.append(predicate)
            case "Gender":
                genderPred.append(predicate)
            default: // Type
                typePred.append(predicate)
            }
        }
        
        let typeCompound = NSCompoundPredicate(type: .or, subpredicates: typePred)
        let ageCompound = NSCompoundPredicate(type: .or, subpredicates: agePred)
        let genderCompound = NSCompoundPredicate(type: .or, subpredicates: genderPred)
        
        if !typePred.isEmpty {
            all = all.filter(typeCompound)
        }
        if !agePred.isEmpty {
            all = all.filter(ageCompound)
        }
        if !genderPred.isEmpty {
            all = all.filter(genderCompound)
        }
        
        let defaults = UserDefaults.standard
        if let state = defaults.string(forKey: UserDefaultKeys.state) {
            if state != "" {
                if let abbreviation = States.getAbbreviationFrom(stateName: state) {
                    let predicate = NSPredicate(format: "%K = %@", "state", abbreviation)
                    all = all.filter(predicate)
                }
            }
        }
        
        return all
    }
    
    func switchFavorite() {
        API.sharedInstance.favorite(pet: self)
        
        let realm = try! Realm()
        try! realm.write {
            favorited = !favorited
        }
    }
}
