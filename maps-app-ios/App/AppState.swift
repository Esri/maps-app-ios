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
    
    var basemaps:[AGSPortalItem] = []
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

    private func updateServices(forPortal portal:AGSPortal) {
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
            
            self.loadBasemaps(portal:portal)
        }
    }

    private func loadBasemaps(portal:AGSPortal) {
        if let basemapGroupQuery = portal.portalInfo?.basemapGalleryGroupQuery {
            let params = AGSPortalQueryParameters(query: basemapGroupQuery)
            portal.findGroups(with: params, completion: { results, error in
                guard error == nil else {
                    print("Unable to get Basemaps Group! \(error!.localizedDescription)")
                    return
                }
                
                guard let results = results else {
                    print("No error, but also no Basemap Group query results!")
                    return
                }
                
                self.basemaps = []
                
                if let basemapGroup = results.results?.first as? AGSPortalGroup, let groupID = basemapGroup.groupID {
                    let groupParams = AGSPortalQueryParameters(forItemsInGroup: groupID)
                    groupParams.limit = 50
                    self.getNextPageOfBasemaps(portal: portal, params: groupParams)
                }
            })
        }
    }
    
    private func getNextPageOfBasemaps(portal:AGSPortal, params: AGSPortalQueryParameters) {
        portal.findItems(with: params, completion: { groupQueryResults, error in
            guard error == nil else {
                print("Error loading items for basemap group: \(error!.localizedDescription)")
                return
            }
            
            guard let basemapItems = groupQueryResults?.results as? [AGSPortalItem] else {
                print("Basemap results were not a set of AGSPortalItems")
                return
            }
            
            self.basemaps.append(contentsOf: basemapItems)
            
            if let nextPageParameters = groupQueryResults?.nextQueryParameters {
                self.getNextPageOfBasemaps(portal: portal, params: nextPageParameters)
            } else {
                self.basemaps.sort(by: { (basemap1, basemap2) -> Bool in
                    return basemap1.title < basemap2.title
                })
            }
        })
    }
}
