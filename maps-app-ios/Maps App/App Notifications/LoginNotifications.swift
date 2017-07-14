//
//  LoginNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/30/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

// MARK: External Notification API
extension MapsAppNotifications {
    // MARK: Register Listeners
    static func observeLoginStateNotifications(loginHandler:((AGSPortalUser)->Void)?, logoutHandler:(()->Void)?) {
        if let loginHandler = loginHandler {
            NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.AppLogin, object: mapsApp, queue: OperationQueue.main) { notification in
                if let loggedInUser = notification.loggedInUser {
                    loginHandler(loggedInUser)
                }
            }
        }
        
        if let logoutHandler = logoutHandler {
            NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.AppLogout, object: mapsApp, queue: OperationQueue.main) { notification in
                logoutHandler()
            }
        }
    }
}



// MARK: Internals
extension MapsAppNotifications {
    static func postLoginNotification(user:AGSPortalUser) {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.AppLogin, object: mapsApp,
                                        userInfo: [LoginNotifications.userKey:user])
    }

    static func postLogoutNotification() {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.AppLogout, object: mapsApp)
    }

}

// MARK: Typed Notification Pattern
extension MapsAppNotifications.Names {
    static let AppLogin = Notification.Name("MapsAppLoginNotification")
    static let AppLogout = Notification.Name("MapsAppLogoutNotification")
}

extension Notification {
    var loggedInUser:AGSPortalUser? {
        if let user = self.userInfo?[LoginNotifications.userKey] as? AGSPortalUser {
            return user
        }
        return nil
    }
}

// MARK: Internal Constants
fileprivate struct LoginNotifications {
    static let userKey = "user"
}
