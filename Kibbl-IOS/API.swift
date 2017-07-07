//
//  API.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/12/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import RealmSwift
import SwiftyJSON
import UserNotifications
import FacebookCore
import FacebookLogin
import PKHUD

extension API {
    enum Headers {
        static let contentType = "Content-Type"
        static let x_www_form_urlencoded = "application/x-www-form-urlencoded"
    }
    
    enum Endpoints {
        static let eventsPoint = "/events"
        static let petsPoint = "/pets"
        static let sheltersPoint = "/shelters"
        static let favorites = "/favorites"
        static let latest = "/latest"
        static let notifications = "/notifications"
        static let login = "/login"
        static let register = "/register"
        static let logout = "/logout"
        static let pushNotifications = "/users/push-notification"
        static let userNotifications = "/notifications/user-notifications"
        static let socialLogin = "/auth/social"
    }
    
    enum KeyPaths {
        static let pets = "pets"
        static let data = "data"
    }
    
    enum Params {
        static let email = "email"
        static let password = "password"
        static let token = "token"
        static let bearer = "Bearer"
        static let age = "age"
        static let type = "type"
        static let gender = "gender"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let lastUpdatedBefore = "lastUpdatedBefore"
        static let createdAtBefore = "createdAtBefore"
        static let location = "location"
        static let itemId = "itemId"
        static let shelterId = "shelterId"
        static let active = "active"
        static let platform = "platform"
        static let deviceToken = "deviceToken"
        static let accessToken = "accessToken"
        static let network = "network"
    }
}

class API {
    let rootURL: String = "http://www.kibbl.io/api/v1";
    
    static let sharedInstance: API = API()
    private init() {}
    
    func login(email: String, password: String, completion: @escaping (_ success: Bool?) -> Void) {
        let urlString = rootURL + Endpoints.login
        
        let _headers : HTTPHeaders = [Headers.contentType:Headers.x_www_form_urlencoded]
        let params : Parameters = [Params.email: email,
                                   Params.password: password]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { response in
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! NSDictionary

                if let message = jsonResponse["message"] {
                    log.error(message)
                    Tracker.logLoginError(string: String(describing: message))
                    Helpers.alertWithMessage(title: Helpers.Alerts.error, message: String(describing: message), completionHandler: nil)
                    return
                }
                
                if let token = jsonResponse["token"] {
                    let user = User()
                    user.email = email
                    user.token = token as? String
                    user.save()
                    completion(true)
                    
                    Tracker.logLogin(user: user)
                    
                    API.sharedInstance.registerForPushNotifications(UIApplication.shared)
                    if let deviceToken = User.getActiveUser()?.deviceToken {
                        API.sharedInstance.setPushNotifications(to: true, deviceToken: deviceToken)
                    }
                    API.sharedInstance.loadLoggedInData()
                }
            case .failure(let error):
                log.error(error)
                Tracker.logLoginError(error: error)
                Helpers.alertWithMessage(title: Helpers.Alerts.error, message: error.localizedDescription, completionHandler: nil)
            }
        }
    }
    
    func socialLogin(socialToken: String, email: String, completion: @escaping (_ success: Bool?) -> Void) {
        let urlString = rootURL + Endpoints.socialLogin
        
        let _headers : HTTPHeaders = [Headers.contentType:Headers.x_www_form_urlencoded]
        let params : Parameters = [Params.accessToken: socialToken,
                                   Params.network: "facebook"]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { response in
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! NSDictionary
                if let message = jsonResponse["message"] {
                    log.error(message)
                    Helpers.alertWithMessage(title: Helpers.Alerts.error, message: String(describing: message), completionHandler: nil)
                    return
                }
                
                if let token = jsonResponse["token"] {
                    let user = User()
                    user.email = email
                    user.token = token as? String
                    user.save()
                    completion(true)
                    
                    Tracker.logFacebookLogin(user: user)
                    
                    API.sharedInstance.registerForPushNotifications(UIApplication.shared)
                    if let deviceToken = User.getActiveUser()?.deviceToken {
                        API.sharedInstance.setPushNotifications(to: true, deviceToken: deviceToken)
                    }
                    API.sharedInstance.loadLoggedInData()
                }
            case .failure(let error):
                log.error(error)
                Tracker.logFacebookLoginError(error: error)
                Helpers.alertWithMessage(title: Helpers.Alerts.error, message: error.localizedDescription, completionHandler: nil)
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping (_ success: Bool?) -> Void) {
        let urlString = rootURL + Endpoints.register
        
        let _headers : HTTPHeaders = [Headers.contentType:Headers.x_www_form_urlencoded]
        let params : Parameters = [Params.email: email,
                                   Params.password: password]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { response in
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! NSDictionary
                
                if let message = jsonResponse["message"] {
                    Tracker.logRegisterError(string: String(describing: message))
                    Helpers.alertWithMessage(title: Helpers.Alerts.error, message: String(describing: message), completionHandler: nil)
                    completion(false)
                }
                
                if let token = jsonResponse["token"] {
                    let user = User()
                    user.email = email
                    user.token = token as? String
                    user.save()
                    Tracker.logRegister(user: user)
                    
                    completion(true)
                    
                    API.sharedInstance.registerForPushNotifications(UIApplication.shared)
                }
            case .failure(let error):
                log.error(error)
                Tracker.logRegisterError(error: error)
            }
        }
    }
    
    func getEvents(createdAtBefore beforeDate: String = "") {
        
        let urlString = rootURL + Endpoints.eventsPoint
        
        var params = [String: String]()
        params[Params.createdAtBefore] = beforeDate
        
        if FilterModel.allActiveCount() != 0 {
            params[Params.startDate] = Date().startOfDay.iso8601String
//            params[Params.endDate] = Date().endOfDay.iso8601String
            
            for filter in FilterModel.getActiveFilterModelsOf(category: "Events") {
                
                if filter.attributeName == "startTimeDate" {
                    params[Params.startDate] = filter.filterValue
                    continue
                }
                if filter.attributeName == "endTimeDate" {
                    params[Params.endDate] = filter.filterValue
                    continue
                }
                
                if filter.attributeName == "locationState" {
                    let stateModel = StateModel.all().filter("abbreviation = %@", filter.filterValue!).first!
                    params[Params.location] = stateModel.name
                    continue
                }
                
                params[filter.attributeName!] = filter.filterValue
            }
        }

        typealias model = EventModel
        
        Alamofire.request(urlString, method: .get, parameters: params).responseArray(keyPath: KeyPaths.data) { (response: DataResponse<[model]>) in
            
            switch response.result {
            case .success:
                let modelsArray = response.result.value
                
                guard let array = modelsArray else { return }
                
                for item in array {

                    // Check if Achievement Model already exists
                    let realm = try! Realm()
                    let existingItem = realm.object(ofType: model.self, forPrimaryKey: item.key)
                    
                    if item.key != existingItem?.key {
                        item.save()
                    }
                    else {
                        // Nothing needs be done.
                    }
                }
            case .failure(let error):
                log.error(error)
                Tracker.logGeneralError(error: error)
            }
        }
    }
    
    func getPets(updatedAtBefore beforeDate: String = "") {
        
        let urlString = rootURL + Endpoints.petsPoint
        
        var params = [String: String]()
        params[Params.lastUpdatedBefore] = beforeDate
        
        let realm = try! Realm()
        if let lastObject = realm.objects(PetModel.self).sorted(byKeyPath: "lastUpdate", ascending: false).last {
            params[Params.lastUpdatedBefore] = lastObject.lastUpdate!
        }
        
        if FilterModel.allActiveCount() != 0 {
            for filter in FilterModel.getActiveFilterModelsOf(category: "Pets") {
                guard filter.filterValue != "" else { continue }
                
                if filter.attributeName == "animal" {
                    params[Params.type] = filter.filterValue
                    continue
                }
                if filter.attributeName == "sex" {
                    params[Params.gender] = filter.filterValue
                    continue
                }
                if filter.attributeName == "state" {
                    let stateModel = StateModel.all().filter("abbreviation = %@", filter.filterValue!).first!
                    params[Params.location] = stateModel.name
                    continue
                }
                
                params[filter.attributeName!] = filter.filterValue
            }
        }

        typealias model = PetModel
        
        Alamofire.request(urlString, method: .get, parameters: params).responseArray(keyPath: KeyPaths.pets) { (response: DataResponse<[model]>) in
            
            switch response.result {
            case .success:
                let modelsArray = response.result.value
                
                guard let array = modelsArray else { return }

                for item in array {

                    // Check if Achievement Model already exists
                    let realm = try! Realm()
                    let existingItem = realm.object(ofType: model.self, forPrimaryKey: item.key)
                    
                    if item.key != existingItem?.key {
                        item.desc = item.desc?.htmlDecoded.replacingOccurrences(of: "&#39;", with: "'")
                        item.save()
                        
                        // Check if filter fufilled here
                    }
                    else {
                        // Nothing needs be done.
                    }
                }
            case .failure(let error):
                log.error(error)
                Tracker.logGeneralError(error: error)
            }
        }
    }
    
    func getShelters(createdAtBefore beforeDate: String = "") {
        let urlString = rootURL + Endpoints.sheltersPoint
        
        var params = [String: String]()
        params[Params.createdAtBefore] = beforeDate
        
        if FilterModel.activeCountOf(category: "Shelter") != 0 {
            for filter in FilterModel.getActiveFilterModelsOf(category: "Shelter") {
                guard filter.filterValue != "" else { continue }
                
                if filter.attributeName == "state" {
                    let stateModel = StateModel.all().filter("abbreviation = %@", filter.filterValue!).first!
                    params[Params.location] = stateModel.name
                    continue
                }
                
                params[filter.attributeName!] = filter.filterValue
            }
        }

        typealias model = ShelterModel
        
        Alamofire.request(urlString, method: .get, parameters: params).responseArray(keyPath: KeyPaths.data) { (response: DataResponse<[model]>) in
            
            switch response.result {
            case .success:
                let modelsArray = response.result.value
                
                guard let array = modelsArray else { return }
                
                for item in array {
                    
                    // Check if Achievement Model already exists
                    let realm = try! Realm()
                    let existingItem = realm.object(ofType: model.self, forPrimaryKey: item.key)
                    
                    if item.key != existingItem?.key {
                        item.save()
                    }
                    else {
                        // Nothing needs be done.
                    }
                }
            case .failure(let error):
                log.error(error)
                Tracker.logGeneralError(error: error)
            }
        }
    }

    func getFollowingShelters() {
        //@TODO: switch this to "following"
        let urlString = rootURL + Endpoints.notifications
        
        guard let user = User.getActiveUser() else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.pleaseLogin, completionHandler: nil)
            return
        }
        guard let userToken = user.token else {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.issueWithUserToken, completionHandler: nil)
            return
        }
        
        let params : Parameters = [Params.token: userToken]
        
        typealias model = ShelterModel
        
        Alamofire.request(urlString, method: .get, parameters: params).responseArray(keyPath: API.KeyPaths.data) { (response: DataResponse<[model]>) in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                let json = JSON(data: data)
                for item in json["data"].arrayValue {
                    
                    if item["shelterId"].null == nil {
                        let newObject = ShelterModel(JSONString: "\(item["shelterId"])")
                        newObject?.following = item["active"].bool!
                        newObject?.save()
                        continue
                    }
                }
            case .failure(let error):
                log.error(error)
                Tracker.logGeneralError(error: error)
                Helpers.alertWithMessage(title: Helpers.Alerts.error, message: error.localizedDescription, completionHandler: nil)
            }
        }
    }
    
    func subscribe(shelter: ShelterModel) {
        //@TODO: write completion
        let id = shelter.key
        
        let urlString = rootURL + Endpoints.notifications
        
        let _headers : HTTPHeaders = [Headers.contentType:Headers.x_www_form_urlencoded]
        
        guard let user = User.getActiveUser() else { return }
        guard let userToken = user.token else { return }
        
        var params : Parameters = [Params.token: userToken]
        params[Params.shelterId] = id!

        Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { response in
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! NSDictionary

                if let message = jsonResponse["message"] {
                    log.error(message)
                    Tracker.logGeneralError(string: String(describing: message))
                    Helpers.alertWithMessage(title: Helpers.Alerts.error, message: String(describing: message), completionHandler: nil)
                    //Completion false
                    shelter.update(following: false)
                    Tracker.logUnsubscribe(shelter: shelter)
                    return
                }
                //Completion true
                shelter.switchSubscribed()
                Tracker.logSubscribe(shelter: shelter)
            case .failure(let error):
                log.error(error)
                Tracker.logGeneralError(error: error)
            }
        }
    }
    
    func favorite(pet: PetModel) {
        
        let petId = pet.key

        let urlString = rootURL + Endpoints.petsPoint + "/" + petId! + "/favorite"
        
        let _headers : HTTPHeaders = [Headers.contentType:Headers.x_www_form_urlencoded]
        
        guard let user = User.getActiveUser() else { return }
        guard let userToken = user.token else { return }
        //@TODO:Make relogin
        
        let params : Parameters = [Params.token: userToken]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { response in
            
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! NSDictionary
                
                if let message = jsonResponse["message"] {
                    log.error(message)
                    Tracker.logGeneralError(string: String(describing: message))
                    Helpers.alertWithMessage(title: Helpers.Alerts.error, message: String(describing: message), completionHandler: nil)
                }
                Tracker.logFavorite(pet: pet)
            case .failure(let error):
                log.error(error)
                Tracker.logGeneralError(error: error)
            }
        }
    }
    
    func favorite(event: EventModel) {
        
        let id = event.key
        
        let urlString = rootURL + Endpoints.favorites
        
        let _headers : HTTPHeaders = [Headers.contentType:Headers.x_www_form_urlencoded]
        
        guard let user = User.getActiveUser() else { return }
        guard let userToken = user.token else { return }
        
        var params : Parameters = [Params.token: userToken]
        params[Params.type] = "event"
        params[Params.itemId] = id!

        Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { response in

            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! NSDictionary

                if let message = jsonResponse["message"] {
                    log.error(message)
                    Tracker.logGeneralError(string: String(describing: message))
                    Helpers.alertWithMessage(title: Helpers.Alerts.error, message: String(describing: message), completionHandler: nil)
                }
                Tracker.logFavorite(event: event)
            case .failure(let error):
                log.error(error)
                Tracker.logGeneralError(error: error)
            }
        }
    }
    
    func getFavorites() {
        
        let urlString = rootURL + Endpoints.favorites
        
        guard let user = User.getActiveUser() else { return }
        guard let userToken = user.token else { return }
        var params = [String: String]()
        params[Params.token] = userToken
        
        Alamofire.request(urlString, method: .get, parameters: params).responseJSON { response in
            switch response.result {
                
            case .success:
                guard let data = response.data else { return }
                let json = JSON(data: data)
                for item in json["data"].arrayValue {

                    if item["petID"].null == nil {
                        let newObject = PetModel(JSONString: "\(item["petID"])")
                        newObject?.favorited = item["active"].bool!
                        newObject?.save()
                        continue
                    }
                    
                    if item["eventId"].null == nil {
                        let newObject = EventModel(JSONString: "\(item["eventId"])")
                        newObject?.favorited = item["active"].bool!
                        newObject?.save()
                        continue
                    }
                }

            case .failure(let error):
                log.error(error)
                Tracker.logGeneralError(error: error)
            }

        }
    }
    
    //@TOOD: write completion handler
    func setPushNotifications(to active: Bool, deviceToken: String) {
        
        let urlString = rootURL + Endpoints.pushNotifications
        
        let _headers : HTTPHeaders = [Headers.contentType:Headers.x_www_form_urlencoded]
        
        var params = [String: String]()
        
        guard User.getActiveUser()?.isLoggedIn() != false else { return }
        guard let user = User.getActiveUser() else { return }
        
        // Check if already set to desirect active state
        guard user.pushNotificationsSetting != active else { return }
        
        guard let userToken = user.token else { return }
        params[Params.token] = userToken
        params[Params.active] = active.string
        params[Params.platform] = "ios"
        guard deviceToken != "" else { return }
        params[Params.deviceToken] = deviceToken
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { response in

            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! NSDictionary
                
                if let message = jsonResponse["message"] {
                    log.error(message)
                    Helpers.alertWithMessage(title: Helpers.Alerts.error, message: String(describing: message), completionHandler: nil)
                    // @TODO: completion
                    return
                }
                // If we made it here that means there was nothing in the response
                // and that's good right now
                // so set user.pushNotificationSetting to desired active state
                user.update(pushNotificationsSetting: active)
                // @TODO: completion
                
            case .failure(let error):
                log.error(error)
                Tracker.logGeneralError(error: error)
            }
            
        }
    }
    
    func getUpdates(withoutSetting: Bool = false) {
        HUD.show(.systemActivity)
        let urlString = rootURL + Endpoints.userNotifications
        
        guard let user = User.getActiveUser() else { return }
        guard let userToken = user.token else { return }
        var params = [String: String]()
        params[Params.token] = userToken
        
        Alamofire.request(urlString, method: .get, parameters: params).responseJSON { response in
            switch response.result {
                
            case .success:
                guard let data = response.data else { return }
                let json = JSON(data: data)

                for item in json["data"].arrayValue {
                    let updatesModel = UpdatesModel(JSONString: "\(item)")
                    var connectingShelter: ShelterModel!
                    let newPets = List<PetModel>()
                    let updatedPets = List<PetModel>()
                    let newEvents = List<EventModel>()
                    let updatedEvents = List<EventModel>()
                    
                    for (index,subJson):(String, JSON) in item {
                        // Indexs:
                        // shelterId = Shelters
                        // newPets
                        // updatedPets
                        // newEvents
                        // updatedEvents
                        
                        if index == "shelterId" {
                            let newModel = ShelterModel(JSONString: "\(item["shelterId"])")
                            // Set shelter to is update
//                            let realm = try! Realm()
//                            if let existingItem = realm.object(ofType: ShelterModel.self, forPrimaryKey: newModel!.key) {
//                                if existingItem.hasUpdates {
//                                    
//                                }
//                                connectingShelter = existingItem
//                                continue
//                            }
                            connectingShelter = newModel
                        }
                        
                        if index == "newPets" {
                            for model in subJson.arrayValue {
                                let newModel = PetModel(JSONString: "\(model)")
                                let realm = try! Realm()
                                if let existingItem = realm.object(ofType: PetModel.self, forPrimaryKey: newModel!.key) {
                                    newPets.append(existingItem)
                                    continue
                                }
                                newPets.append(newModel!)
                            }
                        }
                        
                        if index == "updatedPets" {
                            for model in subJson.arrayValue {
                                let newModel = PetModel(JSONString: "\(model)")
                                let realm = try! Realm()
                                if let existingItem = realm.object(ofType: PetModel.self, forPrimaryKey: newModel!.key) {
                                    updatedPets.append(existingItem)
                                    continue
                                }
                                updatedPets.append(newModel!)
                            }
                        }
                        
                        if index == "newEvents" {
                            for model in subJson.arrayValue {
                                let newModel = EventModel(JSONString: "\(model)")
                                let realm = try! Realm()
                                if let existingItem = realm.object(ofType: EventModel.self, forPrimaryKey: newModel!.key) {
                                    newEvents.append(existingItem)
                                    continue
                                }
                                newEvents.append(newModel!)
                            }
                        }
                        
                        if index == "updatedEvents" {
                            for model in subJson.arrayValue {
                                let newModel = EventModel(JSONString: "\(model)")
                                let realm = try! Realm()
                                if let existingItem = realm.object(ofType: EventModel.self, forPrimaryKey: newModel!.key) {
                                    updatedEvents.append(existingItem)
                                    continue
                                }
                                updatedEvents.append(newModel!)
                            }
                        }
                    }
                    
                    guard connectingShelter != nil else { return }
                    updatesModel?.shelter.append(connectingShelter)
                    
                    let realm = try! Realm()
                    try! realm.write {
                        if !newPets.isEmpty {
                            updatesModel?.newPets.append(contentsOf: newPets)
                        }
                        if !updatedPets.isEmpty {
                            updatesModel?.updatedPets.append(contentsOf: updatedPets)
                        }
                        if !newEvents.isEmpty {
                            updatesModel?.newEvents.append(contentsOf: newEvents)
                        }
                        if !updatedEvents.isEmpty {
                            updatesModel?.updatedEvents.append(contentsOf: updatedEvents)
                        }
                    }
                    updatesModel?.save()
                }
                HUD.hide()
                if withoutSetting == false {
                    UpdatesManager.shared.setHasUpdates()
                }
            case .failure(let error):
                HUD.hide()
                log.error(error)
                Tracker.logGeneralError(error: error)
            }
            
        }
    }
}

extension API {
    // Facebook
    func facebookLogin(completion: @escaping (_ success: Bool?) -> Void) {
//        let loginManager = LoginManager()
//        loginManager.logIn([.publicProfile,.email], viewController: nil, completion: { loginResult in
//            switch loginResult {
//            case .failed(let error):
//                print(error)
//            case .cancelled:
//                print("User cancelled login.")
//            case .success(_,_, let accessToken):
//                print("Logged in!")
//            }
//        })
        
        guard let accessToken = AccessToken.current else { return }
        let params = ["fields":"first_name, last_name, email"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start { (urlResponse, requestResult) in
            switch requestResult {
            case .failed(let error):
                Helpers.alertWithMessage(title: Helpers.Alerts.error, message: error.localizedDescription, completionHandler: nil)
            case .success(let graphResponse):
                // Convert response to dictionary
                guard let responseDictionary = graphResponse.dictionaryValue else { return }
                let email = responseDictionary["email"] as! String
                let firstName = responseDictionary["first_name"] as! String
                let lastName = responseDictionary["last_name"] as! String
                
                
                // Login to Kibbl API
                API.sharedInstance.socialLogin(socialToken: String(describing: accessToken.authenticationToken), email: email, completion: { (success) -> Void in
                    if success == false {
                        completion(false)
                        return
                    }
                    completion(true)
                })
            }
        }
    }
}
extension API {
    func registerForPushNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
}

extension API {
    func createDefaultData() {
            User.createDefault()
            FilterModel.createDefaultFilters()
    }
    
    func loadAllObjects() {
        self.getEvents()
        self.getPets()
        self.getShelters()
    }
    
    func loadLoggedInData() {
        self.getFavorites()
        self.getFollowingShelters()
    }
    
    func reloadAllObjects() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(EventModel.all())
            realm.delete(PetModel.all())
            realm.delete(ShelterModel.all())
            realm.delete(UpdatesModel.all())
        }
        self.getEvents()
        self.getPets()
        self.getShelters()
    }
}

