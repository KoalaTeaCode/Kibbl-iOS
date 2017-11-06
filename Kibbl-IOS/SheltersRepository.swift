//
//  SheltersRepository.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 9/14/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation

public class SheltersRepository: NSObject {
    static let shared: SheltersRepository = SheltersRepository()
    private override init() {}
    
    typealias model = Event
    typealias RepositorySuccessCallback = ([model]) -> Void
    typealias RepositoryErrorCallback = (RepositoryError) -> Void
    
    let realmDataSource = EventsRealmDataSource()
    
    let tag = "shelters"
    
    var loading = false
    
    //@TODO: Add observer pattern
    
    func getData(lastItemDate: String, onSucces: @escaping RepositorySuccessCallback,
                 onFailure: @escaping RepositoryErrorCallback) {
        // Check if we made requests today
        let alreadLoadedStartToday = self.alreadyLoadedNewToday(tag: self.tag, lastItemDate: lastItemDate)
        if alreadLoadedStartToday {
            // Check if we have realm data saved
            //            guard realmDataSource.getAll(at: lastItemDate).isEmpty else {
            //                onSucces(realmDataSource.getAll(at: lastItemDate))
            //                setLoadedNewToday(tagId: self.tag, lastItemDate: lastItemDate)
            //                return
            //            }
            onSucces([model]())
            //            onFailure(.NotFound)
        }
        
        guard self.loading == false else { return }
        self.loading = true
        // We have this here right now until we handle the arrays of events in the repository with an observer pattern
        API.sharedInstance.getShelters(createdAtBefore: lastItemDate) { (success) in
            if success == true {
                self.loading = false
            }
        }
        onSucces([model]())
        
        // API Call and return
        //        API.sharedInstance.getEvents(before: lastItemDate) { (events) in
        //            if let events = events {
        //                for event in events {
        //                    self.realmDataSource.insert(item: event)
        //                }
        //                self.setLoadedNewToday(tagId: self.tag, lastItemDate: lastItemDate)
        //                onSucces(events)
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
        let activeFiltersFromModel = FilterModel.getFiltersAsDictionary(modelType: .shelters)
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
