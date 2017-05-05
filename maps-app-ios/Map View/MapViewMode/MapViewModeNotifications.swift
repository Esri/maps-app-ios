//
//  MapViewModeNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/30/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

extension MapsAppNotifications.Names {
    static let MapViewModeChanged = NSNotification.Name("MapViewModeChangedNotification")
}

extension MapsAppNotifications {
    static func postModeChangeNotification(oldMode:MapViewMode, newMode:MapViewMode) {
        let userInfo = [NSKeyValueChangeKey.oldKey:oldMode, NSKeyValueChangeKey.newKey:newMode]
        NotificationCenter.default.post(name: MapsAppNotifications.Names.MapViewModeChanged, object: nil, userInfo: userInfo)
    }
}

extension Notification {
    var oldMapViewMode:MapViewMode? {
        if self.name == MapsAppNotifications.Names.MapViewModeChanged {
            return self.userInfo?[NSKeyValueChangeKey.oldKey] as? MapViewMode
        }
        return nil
    }

    var newMapViewMode:MapViewMode? {
        if self.name == MapsAppNotifications.Names.MapViewModeChanged {
            return self.userInfo?[NSKeyValueChangeKey.newKey] as? MapViewMode
        }
        return nil
    }
}

