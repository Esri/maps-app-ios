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
        // Remember this portal in the user preferences
        mapsAppPrefs.portalURL = portalURL
        
        // Explicitly log in
        if let url = portalURL {
            mapsAppState.currentPortal = AGSPortal(url: url, loginRequired: true)
        } else {
            mapsAppState.currentPortal = AGSPortal.arcGISOnline(withLoginRequired: true)
        }
    }

    func logOut() {
        // Ensure we forget everything we know about logging in to this portal.
        AGSAuthenticationManager.shared().credentialCache.removeAllCredentials()

        // Make sure our service tasks also forget what they know about being logged into the portal.
        mapsAppState.routeTask.credential = nil
        mapsAppState.locator.credential = nil

        // Explicitly log out
        if let portalURL = mapsAppPrefs.portalURL {
            mapsAppState.currentPortal = AGSPortal(url: portalURL, loginRequired: false)
        } else {
            mapsAppState.currentPortal = AGSPortal.arcGISOnline(withLoginRequired: false)
        }
    }
}
