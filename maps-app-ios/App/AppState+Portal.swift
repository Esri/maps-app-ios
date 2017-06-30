//
//  AppState+Portal.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/30/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

// How many basemaps to get back in a single group items query.
// Can help to avoid loading multiple pages of results.
fileprivate let basemapPageQuerySize = 50

extension AppState {
    func setupAndLoadPortal(portal:AGSPortal) {
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
    
    // MARK: ArcGIS Services
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
    
    // MARK: Basemaps
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
                    groupParams.limit = basemapPageQuerySize
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

