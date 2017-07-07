//
//  APITests.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/22/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

@testable import Kibbl_IOS
import XCTest
import Alamofire
import AlamofireObjectMapper
import RealmSwift
import Quick
import Nimble
import SwiftyJSON

extension APITests {
    enum Headers {
        static let contentType = "Content-Type"
        static let x_www_form_urlencoded = "application/x-www-form-urlencoded"
    }
    
    enum Endpoints {
        static let eventsPoint = "/events?"
        static let petsPoint = "/pets?"
        static let sheltersPoint = "/shelters?"
        static let login = "/login"
        static let register = "/register"
        static let logout = "/logout"
        static let latest = "/latest"
        static let favorites = "/favorites"
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
    }
}

class APITests: QuickSpec {
    var realm: Realm!
    var user: User!
    let rootURL: String = "http://www.kibbl.io/api/v1";
    
    let email = "themisterholliday@gmail.com"
    let password = "A!s2d3F$"

    let date = Date()
    let calendar = Calendar.current
    
    override func spec() {
//        loginTest()
//        getPets()
//        getEvents()
//        getShelters()
//        getNotifications()
//        getLatest()
//        self.setPushNotifications(to: true)
        getUpdates()
    }
}

extension APITests {
    func loginTest() {
        describe("Login") {
            
            beforeEach{
                Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
                
                
                self.realm = try! Realm()
                try! self.realm.write { () -> Void in
                    self.realm.deleteAll()
                }
                
                self.user = User()
            }
            
            afterEach {
                try! self.realm.write {
                    self.realm.deleteAll()
                }
                
                self.user = nil
            }
            
            typealias model = User
            
            let urlString = rootURL + Endpoints.login
            
            let _headers : HTTPHeaders = [Headers.contentType:Headers.x_www_form_urlencoded]
            let params : Parameters = [Params.email: self.email,
                                       Params.password: self.password]
            
            it("can test callbacks using waitUntil") {
                waitUntil(timeout: 10) { done in
                    Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { response in
                        switch response.result {
                        case .success:
                            let jsonResponse = response.result.value as! NSDictionary
                            expect(jsonResponse).toNot(equal(nil))
                            
                            if let message = jsonResponse["message"] {
                                log.error(message)
                                expect(message as? String).toNot(beEmpty())
                            }
                            
                            if let token = jsonResponse["token"] {
                                expect(self.realm.objects(model.self).count).to(equal(0))
                                
                                self.user.email = self.email
                                self.user.token = token as? String
                                try! self.realm.write {
                                    self.realm.add(self.user, update: true)
                                }
                                
                                expect(self.realm.objects(model.self).count).to(equal(1))
                            }
                            log.info("Login Success")
                            done()
                        case .failure(let error):
                            log.error(error)
                            done()
                        }
                    }
                }
            }
        }
    }
    
    func getPets() {
        describe("GetPets") {
            beforeEach{
                Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
                
                
                self.realm = try! Realm()
                try! self.realm.write { () -> Void in
                    self.realm.deleteAll()
                }
                
            }
            
            afterEach {
                try! self.realm.write {
                    self.realm.deleteAll()
                }
                
            }
            
            let urlString = rootURL + Endpoints.petsPoint
            
            it("can test callbacks using waitUntil") {
                waitUntil(timeout: 20) { done in
                    
                    var params = [String: String]()
                    
                    params["lastUpdatedBefore"] = self.date.iso8601String
                    
                    typealias model = PetModel
                    
                    Alamofire.request(urlString, method: .get, parameters: params).responseArray(keyPath: API.KeyPaths.pets) { (response: DataResponse<[model]>) in
                        
                        switch response.result {
                        case .success:
                            
                            let modelsArray = response.result.value
                            
                            guard let array = modelsArray else { return }
                            
                            expect(self.realm.objects(model.self).count).to(equal(0))
                            
                            for item in array {
                                
                                // Check if Achievement Model already exists
                                let existingItem = self.realm.object(ofType: model.self, forPrimaryKey: item.key)
                                
                                if item.key != existingItem?.key {
                                    item.save()
                                }
                                else {
                                    // Nothing needs be done.
                                }
                            }
                            
                            expect(self.realm.objects(model.self).count).to(equal(20))
                            log.info("Get Pets Success")
                            done()
                        case .failure(let error):
                            log.error(error)
                            expect(error).toNot(beNil())
                            done()
                        }
                    }
                }
            }
        }
    }
    
    func getEvents() {
        describe("GetEvents") {
            beforeEach{
                Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
                
                
                self.realm = try! Realm()
                try! self.realm.write { () -> Void in
                    self.realm.deleteAll()
                }
                
            }
            
            afterEach {
                try! self.realm.write {
                    self.realm.deleteAll()
                }
                
            }
            
            let urlString = rootURL + Endpoints.eventsPoint
            
            it("can test callbacks using waitUntil") {
                waitUntil(timeout: 10) { done in
                    
                    var params = [String: String]()
                    
                    params["createdAtBefore"] = self.date.iso8601String
                    
                    typealias model = EventModel
                    
                    Alamofire.request(urlString, method: .get, parameters: params).responseArray(keyPath: API.KeyPaths.data) { (response: DataResponse<[model]>) in
                        
                        switch response.result {
                        case .success:
                            
                            let modelsArray = response.result.value
                            
                            guard let array = modelsArray else { return }
                            
                            expect(self.realm.objects(model.self).count).to(equal(0))
                            
                            for item in array {
                                
                                // Check if Achievement Model already exists
                                let existingItem = self.realm.object(ofType: model.self, forPrimaryKey: item.key)
                                
                                if item.key != existingItem?.key {
                                    item.save()
                                }
                                else {
                                    // Nothing needs be done.
                                }
                            }
                            
                            expect(self.realm.objects(model.self).count).to(equal(20))
                            log.info("Get Events Success")
                            done()
                        case .failure(let error):
                            log.error(error)
                            expect(error).toNot(beNil())
                            done()
                        }
                    }
                }
            }
        }
    }
    
    func getShelters() {
        describe("GetShelters") {
            beforeEach{
                Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
                
                
                self.realm = try! Realm()
                try! self.realm.write { () -> Void in
                    self.realm.deleteAll()
                }
                
            }
            
            afterEach {
                try! self.realm.write {
                    self.realm.deleteAll()
                }
                
            }
            
            let urlString = rootURL + Endpoints.eventsPoint
            
            it("can test callbacks using waitUntil") {
                waitUntil(timeout: 10) { done in
                    
                    var params = [String: String]()
                    
                    params["createdAtBefore"] = self.date.iso8601String
                    
                    typealias model = ShelterModel
                    
                    Alamofire.request(urlString, method: .get, parameters: params).responseArray(keyPath: API.KeyPaths.data) { (response: DataResponse<[model]>) in
                        
                        switch response.result {
                        case .success:
                            
                            let modelsArray = response.result.value
                            
                            guard let array = modelsArray else { return }
                            
                            expect(self.realm.objects(model.self).count).to(equal(0))
                            
                            for item in array {
                                
                                // Check if Achievement Model already exists
                                let existingItem = self.realm.object(ofType: model.self, forPrimaryKey: item.key)
                                
                                if item.key != existingItem?.key {
                                    item.save()
                                }
                                else {
                                    // Nothing needs be done.
                                }
                            }
                            
                            expect(self.realm.objects(model.self).count).to(equal(20))
                            log.info("Get Shelters Success")
                            done()
                        case .failure(let error):
                            log.error(error)
                            expect(error).toNot(beNil())
                            done()
                        }
                    }
                }
            }
        }
    }
    
    func getNotifications() {
        describe("GetNotifications") {
            beforeEach{
                Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
                
                
                self.realm = try! Realm()
                try! self.realm.write { () -> Void in
                    self.realm.deleteAll()
                }
                
            }
            
            afterEach {
                try! self.realm.write {
                    self.realm.deleteAll()
                }
                
            }
            
            let urlString = self.rootURL + Endpoints.sheltersPoint
            
            it("can test callbacks using waitUntil") {
                waitUntil(timeout: 10) { done in
                    
                    typealias model = ShelterModel
                    
                    let params : Parameters = [API.Params.token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyIkX18iOnsic3RyaWN0TW9kZSI6dHJ1ZSwic2VsZWN0ZWQiOnt9LCJnZXR0ZXJzIjp7ImxvY2FsIjp7ImVtYWlsIjoidGhlbWlzdGVyaG9sbGlkYXlAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmEkMDgkeFNDV3l4TFJyYkFEbldHcm1ENHpILllSMUVERTdOa0NDVGQ1Y29GZEhKQzQwZWtxaWRMZTIifX0sIndhc1BvcHVsYXRlZCI6ZmFsc2UsInNjb3BlIjp7Il9pZCI6IjU5MTE0NzUzYmJjOGFhMDAxMWJjY2E2YyIsIl9fdiI6MCwiY3JlYXRlZEF0IjoiMjAxNy0wNS0wOFQxNjozMDoxMS4wMjlaIiwibGltaXRzIjp7Imxhc3RSZXNldCI6IjIwMTctMDUtMDhUMTY6MzA6MTEuMDI5WiIsInN1YnMiOjMsIm1vbnRobHlDb250YWN0cyI6MH0sImxvY2FsIjp7InBhc3N3b3JkIjoiJDJhJDA4JHhTQ1d5eExScmJBRG5XR3JtRDR6SC5ZUjFFREU3TmtDQ1RkNWNvRmRISkM0MGVrcWlkTGUyIiwiZW1haWwiOiJ0aGVtaXN0ZXJob2xsaWRheUBnbWFpbC5jb20ifX0sImFjdGl2ZVBhdGhzIjp7InBhdGhzIjp7ImxpbWl0cy5tb250aGx5Q29udGFjdHMiOiJpbml0IiwibGltaXRzLnN1YnMiOiJpbml0IiwibGltaXRzLmxhc3RSZXNldCI6ImluaXQiLCJjcmVhdGVkQXQiOiJpbml0IiwiX192IjoiaW5pdCIsImxvY2FsLmVtYWlsIjoiaW5pdCIsImxvY2FsLnBhc3N3b3JkIjoiaW5pdCIsIl9pZCI6ImluaXQifSwic3RhdGVzIjp7Imlnbm9yZSI6e30sImRlZmF1bHQiOnt9LCJpbml0Ijp7Il9fdiI6dHJ1ZSwibG9jYWwuZW1haWwiOnRydWUsImxvY2FsLnBhc3N3b3JkIjp0cnVlLCJsaW1pdHMubW9udGhseUNvbnRhY3RzIjp0cnVlLCJsaW1pdHMuc3VicyI6dHJ1ZSwibGltaXRzLmxhc3RSZXNldCI6dHJ1ZSwiY3JlYXRlZEF0Ijp0cnVlLCJfaWQiOnRydWV9LCJtb2RpZnkiOnt9LCJyZXF1aXJlIjp7fX0sInN0YXRlTmFtZXMiOlsicmVxdWlyZSIsIm1vZGlmeSIsImluaXQiLCJkZWZhdWx0IiwiaWdub3JlIl19LCJlbWl0dGVyIjp7ImRvbWFpbiI6bnVsbCwiX2V2ZW50cyI6e30sIl9ldmVudHNDb3VudCI6MCwiX21heExpc3RlbmVycyI6MH19LCJpc05ldyI6ZmFsc2UsIl9kb2MiOnsibG9jYWwiOnsiZW1haWwiOiJ0aGVtaXN0ZXJob2xsaWRheUBnbWFpbC5jb20iLCJwYXNzd29yZCI6IiQyYSQwOCR4U0NXeXhMUnJiQURuV0dybUQ0ekguWVIxRURFN05rQ0NUZDVjb0ZkSEpDNDBla3FpZExlMiJ9LCJmYWNlYm9vayI6e30sInR3aXR0ZXIiOnt9LCJnb29nbGUiOnt9LCJsaW1pdHMiOnsibW9udGhseUNvbnRhY3RzIjowLCJzdWJzIjozLCJsYXN0UmVzZXQiOiIyMDE3LTA1LTA4VDE2OjMwOjExLjAyOVoifSwiY3JlYXRlZEF0IjoiMjAxNy0wNS0wOFQxNjozMDoxMS4wMjlaIiwiX192IjowLCJfaWQiOiI1OTExNDc1M2JiYzhhYTAwMTFiY2NhNmMifSwiaWF0IjoxNDk1NTcxNTcwLCJleHAiOjE2Mzk1NzE1NzB9.PXul5VUAiDEiB10TlobpvmEmpMfLJZe5x4CmQ-Z-Y2I"]
                    
                    //@TODO: Receive multiple objects
                    Alamofire.request(urlString, method: .get, parameters: params).responseArray(keyPath: API.KeyPaths.data) { (response: DataResponse<[model]>) in
                        
                        switch response.result {
                        case .success:
                            
                            let modelsArray = response.result.value
                            
                            guard let array = modelsArray else { return }
                            
                            expect(self.realm.objects(model.self).count).to(equal(0))
                            
                            for item in array {
                                
                                // Check if Achievement Model already exists
                                let existingItem = self.realm.object(ofType: model.self, forPrimaryKey: item.key)
                                
                                if item.key != existingItem?.key {
                                    item.save()
                                }
                                else {
                                    // Nothing needs be done.
                                }
                            }
                            
                            expect(self.realm.objects(model.self).count).to(equal(20))
                            log.info("Get Notifications Success")
                            done()
                        case .failure(let error):
                            log.error(error)
                            expect(error).toNot(beNil())
                            done()
                        }
                    }
                }
            }
        }
    }
    
    func getLatest() {
        describe("GetLatest") {
            beforeEach{
                Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
                
                
                self.realm = try! Realm()
                try! self.realm.write { () -> Void in
                    self.realm.deleteAll()
                }
                
            }
            
            afterEach {
                try! self.realm.write {
                    self.realm.deleteAll()
                }
                
            }
            
            let urlString = rootURL + Endpoints.latest
            
            it("can test callbacks using waitUntil") {
                waitUntil(timeout: 10) { done in
                    
                    var params = [String: String]()
                    
                    typealias model = ShelterModel
                    
                    Alamofire.request(urlString, method: .get, parameters: params, encoding: URLEncoding.httpBody , headers: nil).responseJSON { response in
                        
                        switch response.result {
                        case .success:
                            guard let responseValue = response.result.value else {return}
                            let json = JSON(responseValue)
                            //                            expect(json).toNot(equal(nil))
                            
                            expect(self.realm.objects(PetModel.self).count).to(equal(0))
                            expect(self.realm.objects(ShelterModel.self).count).to(equal(0))
                            expect(self.realm.objects(EventModel.self).count).to(equal(0))
                            
                            let dataJSON = json["data"]
                            for (index,subJson):(String, JSON) in dataJSON {
                                switch index {
                                case "pets":
                                    for item in subJson.arrayValue {
                                        let newModel = PetModel(JSONString: "\(item)")
                                        newModel?.save()
                                    }
                                    continue
                                case "shelters":
                                    for item in subJson.arrayValue {
                                        let newModel = ShelterModel(JSONString: "\(item)")
                                        newModel?.save()
                                    }
                                    continue
                                case "events":
                                    for item in subJson.arrayValue {
                                        let newModel = EventModel(JSONString: "\(item)")
                                        newModel?.save()
                                    }
                                    continue
                                default:
                                    continue
                                }
                            }
                            
                            expect(self.realm.objects(PetModel.self).count).to(equal(3))
                            expect(self.realm.objects(ShelterModel.self).count).to(equal(3))
                            expect(self.realm.objects(EventModel.self).count).to(equal(3))
                            
                            
                            //                            if let message = json["message"] {
                            //                                log.error(message)
                            //                                expect(message as? String).toNot(beEmpty())
                            //                            }
                            log.info("Get Latest Success")
                            done()
                        case .failure(let error):
                            log.error(error)
                            done()
                        }
                    }
                }
            }
        }

    }
    
    func setPushNotifications(to: Bool) {
        let urlString = rootURL + "/push-notification"
        
//        guard let user = User.getActiveUser() else { return }
//        guard let userToken = user.token else { return }
        let _headers : HTTPHeaders = [Headers.contentType:Headers.x_www_form_urlencoded]
        var params = [String: String]()
        params["user"] = ""
        params["user"] = "hollidaycraig@yahoo.com"
        params["deviceToken"] = "1"
        params["active"] = "true"
        params["platform"] = "ios"
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: _headers).responseJSON { response in
            log.info(response)
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                let json = JSON(data: data)
                for item in json["data"].arrayValue {
                    
                }
                
            case .failure(let error):
                log.error(error)
            }
            
        }
    }
    
    func getUpdates() {
        let urlString = rootURL + "/notifications/user-notifications"
        
//        guard let user = User.getActiveUser() else { return }
//        guard let userToken = user.token else { return }
        var params = [String: String]()
        params[Params.token] = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyIkX18iOnsic3RyaWN0TW9kZSI6dHJ1ZSwic2VsZWN0ZWQiOnt9LCJnZXR0ZXJzIjp7ImxvY2FsIjp7ImVtYWlsIjoidGhlbWlzdGVyaG9sbGlkYXlAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmEkMDgkeFNDV3l4TFJyYkFEbldHcm1ENHpILllSMUVERTdOa0NDVGQ1Y29GZEhKQzQwZWtxaWRMZTIifX0sIndhc1BvcHVsYXRlZCI6ZmFsc2UsInNjb3BlIjp7Il9pZCI6IjU5MTE0NzUzYmJjOGFhMDAxMWJjY2E2YyIsIl9fdiI6MCwiY3JlYXRlZEF0IjoiMjAxNy0wNS0wOFQxNjozMDoxMS4wMjlaIiwibGltaXRzIjp7Imxhc3RSZXNldCI6IjIwMTctMDUtMDhUMTY6MzA6MTEuMDI5WiIsInN1YnMiOjMsIm1vbnRobHlDb250YWN0cyI6MH0sImxvY2FsIjp7InBhc3N3b3JkIjoiJDJhJDA4JHhTQ1d5eExScmJBRG5XR3JtRDR6SC5ZUjFFREU3TmtDQ1RkNWNvRmRISkM0MGVrcWlkTGUyIiwiZW1haWwiOiJ0aGVtaXN0ZXJob2xsaWRheUBnbWFpbC5jb20ifX0sImFjdGl2ZVBhdGhzIjp7InBhdGhzIjp7ImxpbWl0cy5tb250aGx5Q29udGFjdHMiOiJpbml0IiwibGltaXRzLnN1YnMiOiJpbml0IiwibGltaXRzLmxhc3RSZXNldCI6ImluaXQiLCJjcmVhdGVkQXQiOiJpbml0IiwiX192IjoiaW5pdCIsImxvY2FsLmVtYWlsIjoiaW5pdCIsImxvY2FsLnBhc3N3b3JkIjoiaW5pdCIsIl9pZCI6ImluaXQifSwic3RhdGVzIjp7Imlnbm9yZSI6e30sImRlZmF1bHQiOnt9LCJpbml0Ijp7Il9fdiI6dHJ1ZSwibG9jYWwuZW1haWwiOnRydWUsImxvY2FsLnBhc3N3b3JkIjp0cnVlLCJsaW1pdHMubW9udGhseUNvbnRhY3RzIjp0cnVlLCJsaW1pdHMuc3VicyI6dHJ1ZSwibGltaXRzLmxhc3RSZXNldCI6dHJ1ZSwiY3JlYXRlZEF0Ijp0cnVlLCJfaWQiOnRydWV9LCJtb2RpZnkiOnt9LCJyZXF1aXJlIjp7fX0sInN0YXRlTmFtZXMiOlsicmVxdWlyZSIsIm1vZGlmeSIsImluaXQiLCJkZWZhdWx0IiwiaWdub3JlIl19LCJlbWl0dGVyIjp7ImRvbWFpbiI6bnVsbCwiX2V2ZW50cyI6e30sIl9ldmVudHNDb3VudCI6MCwiX21heExpc3RlbmVycyI6MH19LCJpc05ldyI6ZmFsc2UsIl9kb2MiOnsibG9jYWwiOnsiZW1haWwiOiJ0aGVtaXN0ZXJob2xsaWRheUBnbWFpbC5jb20iLCJwYXNzd29yZCI6IiQyYSQwOCR4U0NXeXhMUnJiQURuV0dybUQ0ekguWVIxRURFN05rQ0NUZDVjb0ZkSEpDNDBla3FpZExlMiJ9LCJmYWNlYm9vayI6e30sInR3aXR0ZXIiOnt9LCJnb29nbGUiOnt9LCJsaW1pdHMiOnsibW9udGhseUNvbnRhY3RzIjowLCJzdWJzIjozLCJsYXN0UmVzZXQiOiIyMDE3LTA1LTA4VDE2OjMwOjExLjAyOVoifSwiY3JlYXRlZEF0IjoiMjAxNy0wNS0wOFQxNjozMDoxMS4wMjlaIiwiX192IjowLCJfaWQiOiI1OTExNDc1M2JiYzhhYTAwMTFiY2NhNmMifSwiaWF0IjoxNDk1NTcxNTcwLCJleHAiOjE2Mzk1NzE1NzB9.PXul5VUAiDEiB10TlobpvmEmpMfLJZe5x4CmQ-Z-Y2I"
        
        Alamofire.request(urlString, method: .get, parameters: params).responseJSON { response in
            switch response.result {
                
            case .success:
                guard let data = response.data else { return }
                let json = JSON(data: data)
                
                for item in json["data"].arrayValue {
                    
                    var connectingShelter: ShelterModel!
                    
                    for (index,subJson):(String, JSON) in item {
                        // Indexs:
                        // shelterId = Shelters
                        // newPets
                        // updatedPets
                        // newEvents
                        // updatedEvents
                        
                        if index == "shelterId" {
                            let newModel = ShelterModel(JSONString: "\(item)")
                            // Set shelter to is update
                            newModel?.update(isUpdate: true)
                            connectingShelter = newModel
                            newModel?.save()
                        }
                        
                        if index == "newPets" {
                            for model in subJson.arrayValue {
                                let newModel = PetModel(JSONString: "\(model)")
                                let realm = try! Realm()
                                if let existingItem = realm.object(ofType: PetModel.self, forPrimaryKey: newModel!.key) {
                                    connectingShelter.addToNewPets(pet: existingItem)
                                    continue
                                }
                                connectingShelter.addToNewPets(pet: newModel!)
                                newModel?.save()
                            }
                        }
                        
                        if index == "updatedPets" {
                            for model in subJson.arrayValue {
                                let newModel = PetModel(JSONString: "\(model)")
                                let realm = try! Realm()
                                if let existingItem = realm.object(ofType: PetModel.self, forPrimaryKey: newModel!.key) {
                                    connectingShelter.addToUpdatedPets(pet: existingItem)
                                    continue
                                }
                                connectingShelter.addToUpdatedPets(pet: newModel!)
                                newModel?.save()
                            }
                        }
                    }
                }
                
            case .failure(let error):
                log.error(error)
            }
            
        }
    }
}
