//
//  LoginStatus.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/27/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

enum LoginStatus {
    case loggedIn(user:AGSPortalUser)
    case loggedOut
}
