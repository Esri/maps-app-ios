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
        
        NotificationCenter.default.post(name: MapsAppNotifications.Names.Route, object: nil, userInfo: userInfo)
    }
}

extension Notification {
    var routeFrom:AGSStopProvider? {
        if self.name == MapsAppNotifications.Names.Route {
            return self.userInfo?[RouteNotifications.fromKey] as? AGSStopProvider
        }
        return nil
    }

    var routeTo:AGSStopProvider? {
        if self.name == MapsAppNotifications.Names.Route {
            return self.userInfo?[RouteNotifications.toKey] as? AGSStopProvider
        }
        return nil
    }
}

fileprivate struct RouteNotifications {
    static let fromKey = "fromObject"
    static let toKey = "toObject"
}
