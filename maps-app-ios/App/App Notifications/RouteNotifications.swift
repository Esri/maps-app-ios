//
//  RouteNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/1/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapsAppNotifications.Names {
    static let RouteRequested = Notification.Name("MapsAppRouteNotification")
}

extension MapsAppNotifications {
    static func postRouteNotification(from:MapsAppStopProvider?, to:MapsAppStopProvider) {
        var userInfo:[AnyHashable:Any] = [:]
        
        if let from = from {
            userInfo[RouteNotificationKeys.from] = from
        }
        
        userInfo[RouteNotificationKeys.to] = to
        
        NotificationCenter.default.post(name: MapsAppNotifications.Names.RouteRequested, object: nil, userInfo: userInfo)
    }
    
    static func observeRoutingNotifications(routeNotificationHandler:@escaping ((_ fromStop:MapsAppStopProvider?, _ toStop:MapsAppStopProvider)->Void)) {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.RouteRequested, object: nil, queue: nil) { notification in
            guard let to = notification.routeTo else {
                print("No destination provided in the Route Notification!")
                return
            }

            routeNotificationHandler(notification.routeFrom, to)
        }
    }
}

extension Notification {
    var routeFrom:MapsAppStopProvider? {
        if self.name == MapsAppNotifications.Names.RouteRequested {
            return self.userInfo?[RouteNotificationKeys.from] as? MapsAppStopProvider
        }
        return nil
    }

    var routeTo:MapsAppStopProvider? {
        if self.name == MapsAppNotifications.Names.RouteRequested {
            return self.userInfo?[RouteNotificationKeys.to] as? MapsAppStopProvider
        }
        return nil
    }
}

fileprivate struct RouteNotificationKeys {
    static let from = "fromObject"
    static let to = "toObject"
}
