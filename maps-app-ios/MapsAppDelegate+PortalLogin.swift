//
//  MapsAppDelegate+PortalLogin.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/27/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapsAppDelegate {
    func logIn(portalURL:URL?) {
        // Explicitly log in to a portal
        mapsAppPrefs.portalURL = portalURL
        if let url = portalURL {
            currentPortal = AGSPortal(url: url, loginRequired: true)
        } else {
            currentPortal = AGSPortal.arcGISOnline(withLoginRequired: true)
        }
    }

    func logOut() {
        // Explicitly log out of any portal
        AGSAuthenticationManager.shared().credentialCache.removeAllCredentials()

        if let portalURL = mapsAppPrefs.portalURL {
            currentPortal = AGSPortal(url: portalURL, loginRequired: false)
        } else {
            currentPortal = AGSPortal.arcGISOnline(withLoginRequired: false)
        }
    }
}
