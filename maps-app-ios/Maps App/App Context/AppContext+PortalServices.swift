//
//  AppContext+PortalServices.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/14/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension AppContext {
    // MARK: ArcGIS Services
    func updateServices(forPortal portal:AGSPortal) {
        portal.load { error in
            guard error == nil else {
                print("Error loading the portal: \(error!.localizedDescription)")
                return
            }
            
            if let svcs = portal.portalInfo?.helperServices {
                if let geocoderURL = svcs.geocodeServiceURLs?.first, geocoderURL != arcGISServices.locator.url {
                    arcGISServices.locator = AGSLocatorTask(url: geocoderURL)
                }
                
                if let routeTaskURL = svcs.routeServiceURL, routeTaskURL != arcGISServices.routeTask.url {
                    arcGISServices.routeTask = AGSRouteTask(url: routeTaskURL)
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
                    groupParams.limit = AppSettings.basemapPageQuerySize
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
