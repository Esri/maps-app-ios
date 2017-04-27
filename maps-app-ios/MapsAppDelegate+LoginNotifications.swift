//
//  MapsAppDelegate+LoginNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension NotificationCenter {
    func postLoginNotification(user:AGSPortalUser) {
        self.post(name: Notification.Name("MapsAppLogin"), object: self, userInfo: ["user":user])
    }
    
    func postLogoutNotification() {
        self.post(name: Notification.Name("MapsAppLogout"), object: nil)
    }
}

extension MapsAppDelegate {
    func loginChanged() {
        switch loginStatus {
        case .loggedIn(let user):
            print("Logged in as user \(user)")
            NotificationCenter.default.postLoginNotification(user: user)
        case .loggedOut:
            print("Logged out")
            NotificationCenter.default.postLogoutNotification()
        }
    }
}

