//
//  DirectionsViewNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapsAppNotifications.Names {
    static let ManeuverFocus = Notification.Name("DirectionsViewManeuverFocusNotification")
}

extension MapsAppNotifications {
    static func postManeuverFocusNotification(maneuver:AGSDirectionManeuver) {
        var userInfo:[AnyHashable:Any] = [:]
        
        userInfo[DirectionsViewNotificationKeys.maneuver] = maneuver
        
        NotificationCenter.default.post(name: MapsAppNotifications.Names.ManeuverFocus, object: nil, userInfo: userInfo)
    }
    
    static func observeManeuverFocusNotifications(maneuverFocusNotificationHandler:@escaping ((_ maneuver:AGSDirectionManeuver)->Void)) {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.ManeuverFocus, object: nil, queue: nil) { notification in
            guard let maneuver = notification.directionManeuver else {
                print("No maneuver object found for Maneuver Focus Notification!")
                return
            }
            
            maneuverFocusNotificationHandler(maneuver)
        }
    }
}

extension Notification {
    var directionManeuver:AGSDirectionManeuver? {
        if self.name == MapsAppNotifications.Names.ManeuverFocus {
            return self.userInfo?[DirectionsViewNotificationKeys.maneuver] as? AGSDirectionManeuver
        }
        return nil
    }
}

fileprivate struct DirectionsViewNotificationKeys {
    static let maneuver = "directionManeuver"
}
