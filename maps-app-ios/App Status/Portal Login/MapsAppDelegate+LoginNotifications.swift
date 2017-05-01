//
//  MapsAppDelegate+LoginNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapsAppDelegate {
    func loginChanged() {
        switch loginStatus {
        case .loggedIn(let user):
            print("Logged in as user \(user)")
            MapsAppNotifications.postLoginNotification(user: user)
        case .loggedOut:
            print("Logged out")
            MapsAppNotifications.postLogoutNotification()
        }
    }
}

