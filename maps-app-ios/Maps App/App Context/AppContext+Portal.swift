//
//  AppContext+Portal.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/30/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension AppContext {
    func setInitialPortal() {
        // Ensure credentials are cached in the Keychain. Cached credentials could automatically log us in to a portal.
        AGSAuthenticationManager.shared().credentialCache.enableAutoSyncToKeychain(withIdentifier: AppSettings.keychainIdentifier, accessGroup: nil, acrossDevices: false)
        
        // Use a custom Portal URL if we've got one saved
        let savedPortalURL = mapsAppPrefs.portalURL
        
        // Find the "most logged-in portal" we can using any cached credentials.
        // For more info see comments in AGSPortal+Autologin.swift.
        AGSPortal.bestPortalFromCachedCredentials(portalURL: savedPortalURL) { newPortal, didLogIn in
            mapsAppContext.currentPortal = newPortal
        }
    }

    func setupAndLoadPortal(portal:AGSPortal) {
        // Ensure the Runtime knows how to authenticate against this portal should the need arise.
        let oauthConfig = AGSOAuthConfiguration(portalURL: portal.url, clientID: AppSettings.clientID,
                                                redirectURL: "\(AppSettings.appSchema)://\(AppSettings.authURLPath)")
        AGSAuthenticationManager.shared().oAuthConfigurations.add(oauthConfig)
        
        // Now load the portal so we can get some portal-specific information from it.
        portal.load() { error in
            guard error == nil else {
                print("Error loading the portal: \(error!.localizedDescription)")
                return
            }
            
            // Read the locator and route task from the portal.
            self.updateServices(forPortal: portal)
            
            // Record whether we're logged in to this new portal.
            if let user = portal.user {
                self.loginStatus = .loggedIn(user: user)
            } else {
                self.loginStatus = .loggedOut
            }
        }
    }
    
}
