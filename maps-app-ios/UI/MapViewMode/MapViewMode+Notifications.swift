//
//  MapViewMode+Notifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/30/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

extension MapsAppNotifications.Names {
    static let MapViewModeChanged = NSNotification.Name("MapViewModeChanged")
}

extension MapsAppNotifications {
    static func postModeChangeNotification(oldMode:MapViewMode, newMode:MapViewMode) {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.MapViewModeChanged, object: nil, userInfo: [
            NSKeyValueChangeKey.oldKey:oldMode,
            NSKeyValueChangeKey.newKey:newMode
        ])
    }
}
