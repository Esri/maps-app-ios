//
//  AppState.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/5/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

class AppState {
    var locator = AGSLocatorTask(url: AppSettings.worldGeocoderURL)
    var routeTask = AGSRouteTask(url: AppSettings.worldRoutingServiceURL)
    var defaultRouteParameters: AGSRouteParameters?
    
    var currentPortal:AGSPortal? {
        didSet {
            // Forget any authentication rules for the previous portal.
            AGSAuthenticationManager.shared().oAuthConfigurations.removeAllObjects()
            
            if let portal = currentPortal {
                
                // Ensure the Runtime knows how to authenticate against this portal should the need arise.
                let oauthConfig = AGSOAuthConfiguration(portalURL: portal.url, clientID: AppSettings.clientID,
                                                        redirectURL: "\(AppSettings.appSchema)://\(AppSettings.authURLPath)")
                AGSAuthenticationManager.shared().oAuthConfigurations.add(oauthConfig)
                
                print("Portal updated")
                
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
    }
    
    var loginStatus:LoginStatus = .loggedOut {
        didSet {
            switch loginStatus {
            case .loggedIn(let user):
                print("Logged in as user \(user)")
                self.rootFolder = PortalUserFolder.rootFolder(forUser: user)
                MapsAppNotifications.postLoginNotification(user: user)
            case .loggedOut:
                print("Logged out")
                self.rootFolder = nil
                MapsAppNotifications.postLogoutNotification()
            }
        }
    }
    
    var rootFolder:PortalUserFolder? {
        didSet {
            currentFolder = rootFolder
        }
    }
    
    var currentFolder:PortalUserFolder? {
        didSet {
            MapsAppNotifications.postCurrentFolderChangeNotification()
        }
    }
    
    var currentItem:AGSPortalItem? {
        didSet {
            MapsAppNotifications.postCurrentItemChangeNotification()
        }
    }
    
    var isLoggedIn:Bool {
        return self.currentUser != nil
    }
    
    var currentUser:AGSPortalUser? {
        switch self.loginStatus {
        case .loggedIn(let user):
            return user
        case .loggedOut:
            return nil
        }
    }

    func updateServices(forPortal portal:AGSPortal) {
        portal.load { error in
            guard error == nil else {
                print("Error loading the portal: \(error!.localizedDescription)")
                return
            }
            
            if let svcs = portal.portalInfo?.helperServices {
                if let geocoderURL = svcs.geocodeServiceURLs?.first, geocoderURL != self.locator.url {
                    self.locator = AGSLocatorTask(url: geocoderURL)
                }
                
                if let routeTaskURL = svcs.routeServiceURL, routeTaskURL != self.routeTask.url {
                    self.routeTask = AGSRouteTask(url: routeTaskURL)
                }
            }
        }
    }
}
