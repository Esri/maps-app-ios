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
     Log in to the Portal specified by the URL. If no URL is specified, log in to ArcGIS Online.
     
     The portal will be configured for OAuth login and, if necessary, this will trigger the OAuth UI workflow through
     the ArcGIS Runtime SDK.
     
        - Parameters:
            - portalURL: Connect to the portal at the URL provided, or else connect to ArcGIS Online.
     */
    func logIn(portalURL:URL?) {
        // Remember this portal in the user preferences
        AppPreferences.portalURL = portalURL
        
        // Explicitly log in
        if let url = portalURL {
            currentPortal = AGSPortal(url: url, loginRequired: true)
        } else {
            // No URL was provided, so we'll just use ArcGIS Online.
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
        if let portalURL = AppPreferences.portalURL {
            currentPortal = AGSPortal(url: portalURL, loginRequired: false)
        } else {
            // No URL was provided, so we'll just use ArcGIS Online.
            currentPortal = AGSPortal.arcGISOnline(withLoginRequired: false)
        }
    }

}
