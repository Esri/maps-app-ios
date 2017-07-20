//
//  AppContext+Login.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/20/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension AppContext {
    
    /**
     Log in to the Portal specified by the URL. If no URL is specified, log in to ArcGIS Online.
     
     The portal will be configured for OAuth login and, if necessary, this will trigger the OAuth UI workflow through
     the ArcGIS Runtime SDK.
     
        - Parameters:
            - portalURL: Connect to the portal at the URL provided, or else connect to ArcGIS Online.
     */
    func logIn(portalURL:URL?) {
        // Remember this portal in the user preferences
        mapsAppPrefs.portalURL = portalURL
        
        // Explicitly log in
        if let url = portalURL {
            currentPortal = AGSPortal(url: url, loginRequired: true)
        } else {
            currentPortal = AGSPortal.arcGISOnline(withLoginRequired: true)
        }
    }
    
    /**
     Log out of the current portal.
     */
    func logOut() {
        // Ensure we forget everything we know about logging in to this portal.
        AGSAuthenticationManager.shared().credentialCache.removeAllCredentials()
        
        // Make sure our service tasks also forget what they know about being logged into the portal.
        // If we do not do this, even though the portal is not connected, the service tasks may still cache credentials.
        arcGISServices.routeTask.credential = nil
        arcGISServices.locator.credential = nil
        
        // Explicitly log out
        if let portalURL = mapsAppPrefs.portalURL {
            currentPortal = AGSPortal(url: portalURL, loginRequired: false)
        } else {
            currentPortal = AGSPortal.arcGISOnline(withLoginRequired: false)
        }
    }

}
