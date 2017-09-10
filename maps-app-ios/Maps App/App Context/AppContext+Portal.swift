//
//  AppContext+Portal.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/30/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension AppContext {
    
    /**
     Set up the portal on app load. Will read any Portal URL stored in user preferences and then load it, logging in from cached
     credentials if possible.
     */
    func setInitialPortal() {
        // Ensure the Keychain is used for caching credentials.
        // Cached credentials could automatically log us in to a portal.
        AGSAuthenticationManager.shared().credentialCache.enableAutoSyncToKeychain(withIdentifier: AppSettings.keychainIdentifier, accessGroup: nil, acrossDevices: false)
        
        // Use a custom Portal URL if we've got one saved
        let savedPortalURL = mapsAppPrefs.portalURL ?? AppSettings.portalURL
        
        // Find the "most logged-in portal" we can using any cached credentials.
        // For more info see comments in AGSPortal+Autologin.swift.
        AGSPortal.bestPortalFromCachedCredentials(portalURL: savedPortalURL) { newPortal, didLogIn in
            mapsAppContext.currentPortal = newPortal
        }
    }

    /**
     Given an AGSPortal, initialize and load it, configuring it for OAuth authentication, obtaining service task URLs,
     and loading basemaps into the AppContext. Once loaded, see if we are logged in and set the AppContext appropriately.
     */
    func setupAndLoadPortal(portal:AGSPortal) {
        let oAuthRedirectURL = "\(AppSettings.appSchema)://\(AppSettings.authURLPath)"
        // Ensure the Runtime knows how to authenticate against this portal should the need arise.
        let oauthConfig = AGSOAuthConfiguration(portalURL: portal.url, clientID: AppSettings.clientID, redirectURL: oAuthRedirectURL)
        AGSAuthenticationManager.shared().oAuthConfigurations.add(oauthConfig)
        
        // Now load the portal so we can get some portal-specific information from it.
        portal.load() { error in
            guard error == nil else {
                print("Error loading the portal for setup: \(error!.localizedDescription)")
                return
            }
            
            // Read the locator and route task from the portal, and load the basemaps group.
            self.updateServices(forPortal: portal)
            
            // Record whether we're logged in to this new portal.
            if let user = portal.user {
                self.loginStatus = .loggedIn(user: user)
            } else {
                self.loginStatus = .loggedOut
            }
        }
    }
    
    /**
     Try to log in to the AppContext's current portal if possible.
     */
    func logInCurrentPortalIfPossible() {
        // Try to take the current portal and update it to be in a logged in state.
        currentPortal?.load() { error in
            guard error == nil else {
                print("Error loading the portal during login attempt: \(error!.localizedDescription)")
                return
            }
            
            // Only try logging in if the current portal isn't logged in (user == nil)
            // That is, we got here because the AuthenticationManager is being called back from some in-line OAuth
            // success based off a call to a service (an explicit login would set portal.user != nil).
            if let portal = mapsAppContext.currentPortal, let portalURL = portal.url, portal.user == nil {
                AGSPortal.bestPortalFromCachedCredentials(portalURL: portalURL) { newPortalInstance, didLogIn in
                    if didLogIn {
                        // Finally update the current portal if we managed to log in.
                        mapsAppContext.currentPortal = newPortalInstance
                    }
                }
            }
        }
    }

}
