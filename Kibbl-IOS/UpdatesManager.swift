//
//  UpdatesManager.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 6/16/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation

class UpdatesManager: NSObject {
    static let shared: UpdatesManager = UpdatesManager()
    private override init() {}
    
    public var hasUpdates: Bool = false
    
    func setHasUpdates() {
        guard User.getActiveUser()!.isLoggedIn() else { return }
        self.hasUpdates = true
        NotificationCenter.default.post(name: .updates, object: nil)
    }
    
    func clearHasUpdates() {
        self.hasUpdates = false
        NotificationCenter.default.post(name: .updates, object: nil)
    }
}
