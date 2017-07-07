//
//  UserModel.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/23/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import SwifterSwift
import FacebookLogin

public class User: Object, Mappable {
    dynamic var key = 1
    dynamic var firstName: String? = nil
    dynamic var lastName: String? = nil
    dynamic var email: String? = nil
    dynamic var token: String? = nil
    dynamic var pushNotificationsSetting: Bool = false
    dynamic var deviceToken: String = ""
    
    override public static func primaryKey() -> String? {
        return "key"
    }
    
    //Impl. of Mappable protocol
    required convenience public init?(map: Map) {
        self.init()
    }
    
    // Mappable
    public func mapping(map: Map) {
        key <- map["id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        token <- map["token"]
    }
    
    // Mark: Getters
    
    func getFullName() -> String? {
        return self.firstName! + self.lastName!
    }
    
    func isLoggedIn() -> Bool {
        if token != nil && token != "" {
            return true
        }
        return false
    }
}

extension User {
    func save() {
        // @TODO: Make sure there's only one user at a given time
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    // Probably rename this to something more understandable
    class func checkAndAlert() -> Bool {
        let realm = try! Realm()
        let user = realm.objects(User.self).first
        
        if user?.token == nil || user?.token == "" {
            Helpers.alertWithMessage(title: Helpers.Alerts.error, message: Helpers.Messages.youMustLogin, completionHandler: nil)
            return false
        }
        return true
    }
    
    class func getActiveUser() -> User? {
        let realm = try! Realm()
        return realm.objects(User.self).first
    }
    
    class func all() -> Results<User> {
        let realm = try! Realm()
        return realm.objects(User.self)
    }
    
    class func logout() {
        let user = User()
        user.firstName = ""
        user.lastName = ""
        user.email = ""
        user.token = ""
        user.save()
        
        // Logout of facebook 
        let loginManager = LoginManager()
        loginManager.logOut()
        
        // Alert with success
        Helpers.alertWithMessage(title: Helpers.Alerts.success, message: Helpers.Messages.logoutSuccess)
        
        // Reload Data
        API.sharedInstance.reloadAllObjects()
        NotificationCenter.default.post(name: .loggedOut, object: nil)
    }
    
    class func createDefault() {
        guard self.getActiveUser() == nil else { return }
        let user = User()
        user.email = ""
        user.token = ""
        user.save()
    }
    
    func delete() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    func update(deviceToken: String) {
        let realm = try! Realm()
        try! realm.write {
            self.deviceToken = deviceToken
        }
    }
    
    func update(pushNotificationsSetting: Bool) {
        let realm = try! Realm()
        try! realm.write {
            self.pushNotificationsSetting = pushNotificationsSetting
        }
    }
}
