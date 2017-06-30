//
//  BasemapNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/19/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation
import ArcGIS

extension MapsAppNotifications.Names {
    static let NewBasemap = NSNotification.Name("MapsAppNewBasemapNotification")
}

extension MapsAppNotifications {
    static func postNewBasemapNotification(basemap:AGSPortalItem) {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.NewBasemap, object: mapsApp, userInfo: [
            BasemapNotificationKeys.basemap : AGSBasemap(item: basemap)
        ])
    }
}

extension Notification {
    var basemap:AGSBasemap? {
        get {
            if [MapsAppNotifications.Names.NewBasemap].contains(self.name) {
                return self.userInfo?[BasemapNotificationKeys.basemap] as? AGSBasemap
            }
            return nil
        }
    }
}

fileprivate struct BasemapNotificationKeys {
    static let basemap = "basemapItem"
}
