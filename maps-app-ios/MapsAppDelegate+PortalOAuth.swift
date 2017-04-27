//
//  MapsAppDelegate+PortalOAuth.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

extension MapsAppDelegate {
    func portalAuth(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle OAuth callback
        if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            urlComponents.scheme == MapsAppSettings.appSchema,
            urlComponents.host == MapsAppSettings.authURLPath {
            let sourceApp = options[.sourceApplication] as? String
            let annotation = options[.annotation]
            AGSApplicationDelegate.shared().application(app, open: url, sourceApplication: sourceApp, annotation: annotation)
            
            if let _ = urlComponents.queryParameter(named: "code") {
                // If we were authenticated, there should now be a shared credential to use. Let's try it.
                logInCurrentPortalIfPossible()
            }
        }
        return true
    }
    
    func logInCurrentPortalIfPossible() {
        // Try to take the current portal and update it to be in a logged in state.
        currentPortal?.load() { error in
            if let portal = self.currentPortal, let portalURL = portal.url, portal.user == nil {
                AGSPortal.bestPortalFromCachedCredentials(portalURL: portalURL) { (newPortalInstance, didLogIn) in
                    if didLogIn {
                        self.currentPortal = newPortalInstance
                    }
                }
            }
        }
    }
}

