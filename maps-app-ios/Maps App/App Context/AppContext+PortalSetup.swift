// Copyright 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import ArcGIS

extension AppContext {
    
    /**
     Set up the portal on app load. Will read any Portal URL stored in user preferences and then load it, signing in from cached
     credentials if possible.
     */
    func setInitialPortal() {
        // Ensure the Keychain is used for caching credentials.
        // Cached credentials could automatically sign us in to a portal.
        AGSAuthenticationManager.shared().credentialCache.enableAutoSyncToKeychain(withIdentifier: AppSettings.keychainIdentifier, accessGroup: nil, acrossDevices: false)
        
        // Use a custom Portal URL if we've got one saved
        let savedPortalURL = AppPreferences.portalURL ?? AppSettings.portalURL
        
        // Find the "most signed-in portal" we can using any cached credentials.
        // For more info see comments in AGSPortal+AutoLogin.swift.
        AGSPortal.bestPortalFromCachedCredentials(portalURL: savedPortalURL) { newPortal, _ in
            mapsAppContext.currentPortal = newPortal
        }
    }

    /**
     Given an AGSPortal, initialize and load it, configuring it for OAuth authentication, obtaining service task URLs,
     and loading basemaps into the AppContext. Once loaded, see if we are signed in and set the AppContext appropriately.
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
            
            // Record whether we're signed in to this new portal.
            self.currentUser = portal.user
        }
    }
    
    /**
     Try to sign in to the AppContext's current portal if possible.
     */
    func signInCurrentPortalIfPossible() {
        // Try to take the current portal and update it to be in a signed-in state.
        currentPortal?.load() { error in
            guard error == nil else {
                print("Error loading the portal during sign-in attempt: \(error!.localizedDescription)")
                return
            }
            
            // Only try signing in if the current portal isn't signed in (user == nil)
            // That is, we got here because the AuthenticationManager is being called back from some in-line OAuth
            // success based off a call to a service (an explicit login would set portal.user != nil).
            if let portal = mapsAppContext.currentPortal, let portalURL = portal.url, portal.user == nil {
                AGSPortal.bestPortalFromCachedCredentials(portalURL: portalURL) { newPortalInstance, didSignIn in
                    if didSignIn {
                        // Finally update the current portal if we managed to sign in.
                        mapsAppContext.currentPortal = newPortalInstance
                    }
                }
            }
        }
    }

}
