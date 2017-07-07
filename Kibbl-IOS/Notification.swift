//
//  Notification.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/30/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let filterChanged = Notification.Name("filterChanged")
    static let eventsChanged = Notification.Name("eventsChanged")
    static let petsChanged = Notification.Name("petsChanged")
    static let loggedOut = Notification.Name("loggedOut")
    static let updates = Notification.Name("updates")
}
