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
    static let CurrentFolderChanged = NSNotification.Name("CurrentFolderChangedNotification")
}

extension MapsAppNotifications {
    static func postPortalItemChangeNotification() {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.PortalItemChanged, object: mapsApp, userInfo: nil)
    }
    
    static func postCurrentFolderChangeNotification() {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.CurrentFolderChanged, object: mapsApp, userInfo: nil)
    }
}
