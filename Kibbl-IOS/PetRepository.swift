//
//  PetRepository.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 9/12/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation

enum APICheckDates {
    static let newFeedLastCheck = "newFeed"
}

enum RepositoryError: Error {
    case NotFound
}

enum ModelTypes {
    case pets
    case events
    case shelters
}

public class PetRepository: NSObject {
    static let shared: PetRepository = PetRepository()
    private override init() {}
    
    typealias model = Pet
    typealias RepositorySuccessCallback = ([model]) -> Void
    typealias RepositoryErrorCallback = (RepositoryError) -> Void
    
    let realmDataSource = PetsRealmDataSource()
    
    let tag = "pets"
    var loading = false
    
    //@TODO: Add observer pattern
    
    func getData(lastItemDate: String, onSucces: @escaping RepositorySuccessCallback,
                onFailure: @escaping RepositoryErrorCallback) {
        // Check if we made requests today
        let alreadLoadedStartToday = self.alreadyLoadedNewToday(tag: self.tag, lastItemDate: lastItemDate)

        if alreadLoadedStartToday {
            // Check if we have realm data saved
            // @TODO: Change this to get with filter
//            guard realmDataSource.getAll().isEmpty else {
//                onSucces(realmDataSource.getAll())
//                setLoadedNewToday(tagId: self.tag, lastItemDate: lastItemDate)
//                return
//            }
            onSucces([model]())
            onFailure(.NotFound)
        }
        
        guard self.loading == false else { return }
        self.loading = true
        API.sharedInstance.getPets(updatedAtBefore: lastItemDate) { (success) in
            if success == true {
                self.loading = false
            }
        }
        onSucces([model]())

        // API Call and return
//        API.sharedInstance.getPets { (pets) in
//            if let pets = pets {
//                for pet in pets {
//                    self.realmDataSource.insert(item: pet)
//                }
//                self.setLoadedNewToday(tagId: self.tag, lastItemDate: lastItemDate)
//                self.getData(lastItemDate: lastItemDate, onSucces: { (pets) in
//                    onSucces(pets)
//                }, onFailure: { (error) in
//                    onFailure(error)
//                })
//                return
//            }
//            onFailure(.NotFound)
//        }
    }
    
    func alreadyLoadedNewToday (tag: String, lastItemDate: String?) -> Bool {
        let defaults = UserDefaults.standard
        // @TODO: we may be able to add this to the filters dictionary
        var key = APICheckDates.newFeedLastCheck
        
        var filters = [String: String]()
        filters[FilterKeys.lastItemDate] = lastItemDate
        filters[FilterKeys.tag] = String(tag)
        
        // Get filter model params (temp)
        let activeFiltersFromModel = FilterModel.getFiltersAsDictionary(modelType: .pets)
        filters += activeFiltersFromModel
        
        key = "\(key)-\(filters.description)"
        
        if let newFeedLastCheck = defaults.string(forKey: key) {
            let todayDate = Date().dateString()
            let newFeedDate = Date(iso8601String: newFeedLastCheck)!.dateString()
            if (newFeedDate == todayDate) {
                return true
            }
            
            return false
        }
        return false
    }
    
    func setLoadedNewToday (tagId: String, lastItemDate: String?) {
        let todayString = Date().iso8601String
        var key = APICheckDates.newFeedLastCheck
        
        var filters = [String: String]()
        filters[FilterKeys.lastItemDate] = lastItemDate
        filters[FilterKeys.tag] = String(tag)
        
        key = "\(key)-\(filters.description)"
        
        let defaults = UserDefaults.standard
        defaults.set(todayString, forKey: key)
    }
}

extension Dictionary {
    static func += (left: inout Dictionary, right: Dictionary) {
        for (key, value) in right {
            left[key] = value
        }
    }
}
