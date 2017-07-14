//
//  MapViewControllerNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/8/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation
import ArcGIS

extension MapsAppNotifications {
    static func postMapViewResetExtentForModeNotification() {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.MapViewResetExtentForMode, object: nil)
    }
    
    static func postMapViewRequestFocusOnExtentNotification(extent: AGSEnvelope) {
        let userInfo = [MapViewNotificationKeys.extent:extent]
        NotificationCenter.default.post(name: MapsAppNotifications.Names.MapViewReqestFocusOnExtent, object: nil, userInfo: userInfo)
    }
}

extension MapsAppNotifications.Names {
    static let MapViewResetExtentForMode = NSNotification.Name("MapViewResetExtentForModeNotification")
    static let MapViewReqestFocusOnExtent = NSNotification.Name("MapViewRequestFocusOnExtentNotification")
}

extension Notification {
    var requestedExtent:AGSEnvelope? {
        if self.name == MapsAppNotifications.Names.MapViewReqestFocusOnExtent {
            return self.userInfo?[MapViewNotificationKeys.extent] as? AGSEnvelope
        }
        return nil
    }
}

fileprivate struct MapViewNotificationKeys {
    static let extent = "extent"
}
