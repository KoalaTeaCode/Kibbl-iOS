//
//  Tracker.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/30/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

//Web Views
//Registrants
//Installs
//Uninstalls
//Returning Users
//Follows
//FAvorites


import Foundation
import Crashlytics

class Tracker {    
    class func logMovedToWebView(url: String) {
        Answers.logCustomEvent(withName: "Moved_To_Webview",
                               customAttributes:
            [
                "website": url
            ]
        )
    }
    
    //@MARK: Shelter Model
    
    class func logSubscribe(shelter: ShelterModel) {
        Answers.logCustomEvent(withName: "Subscribe_Shelter",
                               customAttributes:
            [
                "rescueGroupId": shelter.rescueGroupId
                ,"country": shelter.country
                ,"shelterName": shelter.name
                ,"state": shelter.state
                ,"city": shelter.city
                ,"zip": shelter.zip
                ,"orgType": shelter.orgType
            ]
        )
    }
    
    class func logUnsubscribe(shelter: ShelterModel) {
        Answers.logCustomEvent(withName: "Unsubscribe_Shelter",
                               customAttributes:
            [
                "rescueGroupId": shelter.rescueGroupId
                ,"country": shelter.country
                ,"shelterName": shelter.name
                ,"state": shelter.state
                ,"city": shelter.city
                ,"zip": shelter.zip
                ,"orgType": shelter.orgType
            ]
        )
    }
    
    //@MARK: Pet model
    
    class func logFavorite(pet: PetModel) {
        switch pet.favorited {
        case false:
            logUnfavorite(pet: pet)
            return
        default: // true
            Answers.logCustomEvent(withName: "Favorite_Pet",
                                   customAttributes:
                [
                    "petName":pet.name
                    ,"sex":pet.sex
                    ,"age":pet.age
                    ,"status":pet.status
                    ,"size":pet.size
                    ,"animal":pet.animal
                    ,"breed1":pet.breed1
                    ,"breed2":pet.breed2
                    ,"breed3":pet.breed3
                    ,"zipcode":pet.state
                    ,"state":pet.zipcode
                    ,"locationName":pet.locationName
                    ,"shelterId":pet.shelterId
                    ,"websiteURL":pet.websiteURL
                ]
            )
        }
    }
    
    class func logUnfavorite(pet: PetModel) {
        Answers.logCustomEvent(withName: "Unfavorite_pet",
                               customAttributes:
            [
                "petName":pet.name
                ,"sex":pet.sex
                ,"age":pet.age
                ,"status":pet.status
                ,"size":pet.size
                ,"animal":pet.animal
                ,"breed1":pet.breed1
                ,"breed2":pet.breed2
                ,"breed3":pet.breed3
                ,"zipcode":pet.state
                ,"state":pet.zipcode
                ,"locationName":pet.locationName
                ,"shelterId":pet.shelterId
                ,"websiteURL":pet.websiteURL
            ]
        )
    }
    
    //@MARK: Event model
    
    class func logFavorite(event: EventModel) {
        switch event.favorited {
        case false:
            logUnfavorite(event: event)
            return
        default: // true
            Answers.logCustomEvent(withName: "Favorite_Pet",
                                   customAttributes:
                [
                    "eventName": event.name
                    ,"shelterId": event.shelterId
                    ,"locationName": event.locationName
                    ,"locationCity": event.locationCity
                    ,"locationCountry": event.locationCountry
                    ,"locationState": event.locationState
                    ,"locationZip": event.locationZip
                ]
            )
        }
    }
    
    class func logUnfavorite(event: EventModel) {
        Answers.logCustomEvent(withName: "Unfavorite_pet",
                               customAttributes:
            [
                "eventName": event.name
                ,"shelterId": event.shelterId
                ,"locationName": event.locationName
                ,"locationCity": event.locationCity
                ,"locationCountry": event.locationCountry
                ,"locationState": event.locationState
                ,"locationZip": event.locationZip
            ]
        )
    }
    
    class func logLogin(user: User) {
        Answers.logLogin(withMethod: "Kibble_API", success: 1, customAttributes:
            [
            "username": user.email
            ]
        )
    }
    
    class func logRegister(user: User) {
        Answers.logCustomEvent(withName: "Register",
                               customAttributes:
            [
                "username": user.email
            ]
        )
    }
    
    class func logFacebookLogin(user: User) {
        Answers.logLogin(withMethod: "Facebook", success: 1, customAttributes:
            [
            "username": user.email
            ]
        )
    }
}

extension Tracker {
    //MARK: errors
    
    class func logLoginError(error: Error) {
        Answers.logLogin(withMethod: "Kibble_API", success: 0, customAttributes:
            [
                "error": error.localizedDescription
            ]
        )
    }
    
    class func logLoginError(string: String) {
        Answers.logLogin(withMethod: "Kibble_API", success: 0, customAttributes:
            [
                "error": string
            ]
        )
    }
    
    class func logRegisterError(error: Error) {
        Answers.logCustomEvent(withName: "Error_Register",
                               customAttributes:
            [
                "error": error.localizedDescription
            ]
        )
    }
    
    class func logRegisterError(string: String) {
        Answers.logCustomEvent(withName: "Error_Register",
                               customAttributes:
            [
                "error": string
            ]
        )
    }
    
    class func logFacebookLoginError(error: Error) {
        Answers.logLogin(withMethod: "Facebook_Login", success: 0, customAttributes:
            [
                "error": error.localizedDescription
            ]
        )
    }
    
    class func logGeneralError(error: Error) {
        Answers.logCustomEvent(withName: "Error_General",
                               customAttributes:
            [
                "error": error.localizedDescription
            ]
        )
    }
    
    class func logGeneralError(string: String) {
        Answers.logCustomEvent(withName: "Error_General",
                               customAttributes:
            [
                "error": string
            ]
        )
    }
}
