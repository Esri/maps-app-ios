//
//  RouteNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/1/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapsAppNotifications.Names {
    static let RouteSolved = Notification.Name("MapsAppRouteSolvedNotification")
}

extension MapsAppNotifications {
    static func postRouteResultNotification(result:AGSRoute) {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.RouteSolved, object: nil, userInfo: [RouteNotificationKeys.route:result])
    }
    
    static func observeRouteSolvedNotification(routeSolvedHandler: @escaping ((AGSRoute)->Void)) {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.RouteSolved, object: nil, queue: OperationQueue.main) { notification in
            if let routeResult = notification.routeResult {
                routeSolvedHandler(routeResult)
            }
        }
    }
}

extension Notification {
    var routeResult:AGSRoute? {
        if self.name == MapsAppNotifications.Names.RouteSolved {
            return self.userInfo?[RouteNotificationKeys.route] as? AGSRoute
        }
        return nil
    }
}

fileprivate struct RouteNotificationKeys {
    static let route = "route"
}
