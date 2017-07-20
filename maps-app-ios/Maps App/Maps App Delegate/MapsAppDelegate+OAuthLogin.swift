//
//  MapsAppDelegate+PortalOAuth.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapsAppDelegate {
    
    // MARK: OAuth
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle OAuth callback from application(app,url,options) when the app's URL schema is called.
        //
        // See also AppSettings and AppContext.setupAndLoadPortal() to see how the AGSPortal is configured
        // to handle OAuth and call back to this application.
        if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            urlComponents.scheme == AppSettings.appSchema, urlComponents.host == AppSettings.authURLPath {
            
            // Pass the OAuth callback through to the ArcGIS Runtime helper function
            AGSApplicationDelegate.shared().application(app, open: url, options: options)
            
            // See if we were called back with confirmation that we're authorized.
            if let _ = urlComponents.queryParameter(named: "code") {
                // If we were authenticated, there should now be a shared credential to use. Let's try it.
                mapsAppContext.logInCurrentPortalIfPossible()
            }
        }
        return true
    }
    
}
