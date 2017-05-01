//
//  RouteNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/1/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapsAppNotifications.Names {
    static let Route = Notification.Name("MapsAppRouteNotification")
}

extension MapsAppNotifications {
    static func postRouteNotification(from:AGSStopProvider?, to:AGSStopProvider) {
        var userInfo:[AnyHashable:Any] = [:]
        
        if let from = from {
            userInfo[RouteNotifications.fromKey] = from
        }
        
        userInfo[RouteNotifications.toKey] = to
        
        let notification = Notification(name: MapsAppNotifications.Names.Route, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }
}

extension Notification {
    var routeFrom:AGSStopProvider? {
        get {
            if self.name == MapsAppNotifications.Names.Route {
                return self.userInfo?[RouteNotifications.fromKey] as? AGSStopProvider
            }
            return nil
        }
    }

    var routeTo:AGSStopProvider? {
        get {
            if self.name == MapsAppNotifications.Names.Route {
                return self.userInfo?[RouteNotifications.toKey] as? AGSStopProvider
            }
            return nil
        }
    }
}

fileprivate struct RouteNotifications {
    static let fromKey = "fromObject"
    static let toKey = "toObject"
}
