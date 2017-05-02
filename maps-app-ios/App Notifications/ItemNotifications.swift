//
//  ItemNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/2/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

extension MapsAppNotifications.Names {
    static let PortalItemChanged = NSNotification.Name("PortalItemChangedNotification")
}

extension MapsAppNotifications {
    static func postPortalItemChangeNotification() {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.PortalItemChanged, object: mapsApp, userInfo: nil)
    }
}
