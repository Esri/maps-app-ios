//
//  AppState.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/5/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

class AppContext {
    // MARK: ArcGIS Services
    var locator = AGSLocatorTask(url: AppSettings.worldGeocoderURL)
    var routeTask = AGSRouteTask(url: AppSettings.worldRoutingServiceURL)
    var defaultRouteParameters: AGSRouteParameters?
    
    // MARK: Portal Information
    var currentPortal:AGSPortal? {
        didSet {
            // Forget any authentication rules for the previous portal.
            AGSAuthenticationManager.shared().oAuthConfigurations.removeAllObjects()
            
            if let portal = currentPortal {
                setupAndLoadPortal(portal: portal)
            }
        }
    }
    
    var basemaps:[AGSPortalItem] = []
    var currentBasemap:AGSPortalItem? {
        didSet {
            if let newBasemap = currentBasemap {
                MapsAppNotifications.postNewBasemapNotification(basemap: newBasemap)
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

    // MARK: Loging Status
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

    // MARK: MapView UI
    var currentMapView:AGSMapView?
    var validToShowSuggestions:Bool = true {
        didSet {
            if !validToShowSuggestions {
                MapsAppNotifications.postSearchSuggestionsAvailableNotification(suggestions: [])
            }
        }
    }
}
