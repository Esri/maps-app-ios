//
//  RouteNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/1/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

// MARK: External Notification API
extension MapsAppNotifications {
    // MARK: Register Listeners
    static func observeRouteSolvedNotification(routeSolvedHandler: @escaping ((AGSRoute)->Void)) {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.RouteSolved, object: mapsApp, queue: OperationQueue.main) { notification in
            if let routeResult = notification.routeResult {
                routeSolvedHandler(routeResult)
            }
        }
    }
}



// MARK: Internals
extension MapsAppNotifications {
    static func postRouteResultNotification(result:AGSRoute) {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.RouteSolved, object: mapsApp, userInfo: [RouteNotificationKeys.route:result])
    }
    
}

// MARK: Typed Notification Pattern
extension MapsAppNotifications.Names {
    static let RouteSolved = Notification.Name("MapsAppRouteSolvedNotification")
}

extension Notification {
    var routeResult:AGSRoute? {
        if self.name == MapsAppNotifications.Names.RouteSolved {
            return self.userInfo?[RouteNotificationKeys.route] as? AGSRoute
        }
        return nil
    }
}

// MARK: Internal Constants
fileprivate struct RouteNotificationKeys {
    static let route = "route"
}
