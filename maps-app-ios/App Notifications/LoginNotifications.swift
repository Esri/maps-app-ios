//
//  LoginNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/30/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

fileprivate struct LoginNotifications {
    static let userKey = "user"
}

extension MapsAppNotifications {
    static func postLoginNotification(user:AGSPortalUser) {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.AppLogin, object: self, userInfo: [LoginNotifications.userKey:user])
    }
    
    static func postLogoutNotification() {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.AppLogout, object: nil)
    }
}

extension MapsAppNotifications.Names {
    static let AppLogin = Notification.Name("MapsAppLogin")
    static let AppLogout = Notification.Name("MapsAppLogout")
}
