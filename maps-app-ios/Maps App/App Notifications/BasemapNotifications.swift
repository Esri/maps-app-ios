//
//  BasemapNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/19/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

// MARK: External Notification API
extension MapsAppNotifications {
    static func observeBasemapChangedNotification(handler:@escaping ((AGSBasemap)->Void)) {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.CurrentBasemapChanged, object: mapsApp, queue: OperationQueue.main) { notification in
            // The user selected a new basemap. Let's show it in the MapView.
            if let newBasemap = notification.basemap {
                handler(newBasemap)
            }
        }
    }
}



// MARK: Internals
extension MapsAppNotifications {
    static func postCurrentBasemapChangedNotification(basemap:AGSPortalItem) {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.CurrentBasemapChanged, object: mapsApp, userInfo: [
            BasemapNotificationKeys.basemap : AGSBasemap(item: basemap)
        ])
    }
}

// MARK: Typed Notification Pattern
extension MapsAppNotifications.Names {
    static let CurrentBasemapChanged = NSNotification.Name("MapsAppCurrentBasemapChangedNotification")
}

extension Notification {
    var basemap:AGSBasemap? {
        get {
            if [MapsAppNotifications.Names.CurrentBasemapChanged].contains(self.name) {
                return self.userInfo?[BasemapNotificationKeys.basemap] as? AGSBasemap
            }
            return nil
        }
    }
}

// MARK: Internal Constants
fileprivate struct BasemapNotificationKeys {
    static let basemap = "basemapItem"
}
