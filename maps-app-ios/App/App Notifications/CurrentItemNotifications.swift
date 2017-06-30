//
//  CurrentItemNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/2/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

extension MapsAppNotifications.Names {
    static let CurrentItemChanged = NSNotification.Name("MapsAppCurrentItemChangedNotification")
    static let CurrentFolderChanged = NSNotification.Name("MapsAppCurrentFolderChangedNotification")
}

extension MapsAppNotifications {
    static func postCurrentItemChangeNotification() {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.CurrentItemChanged, object: mapsApp, userInfo: nil)
    }
    
    static func postCurrentFolderChangeNotification() {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.CurrentFolderChanged, object: mapsApp, userInfo: nil)
    }
}
