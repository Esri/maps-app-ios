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

    // MARK: ArcGIS Services
    /**
     Given an AGSPortal, retrieve the service URLs for Route and Geocoding tasks, and load the basemaps group.
    */
    func updateServices(forPortal portal:AGSPortal) {
        portal.load { error in
            guard error == nil else {
                print("Error loading the portal to update services: \(error!.localizedDescription)")
                return
            }
            
            if let svcs = portal.portalInfo?.helperServices {
                if let geocoderURL = svcs.geocodeServiceURLs?.first, geocoderURL != arcGISServices.locator.url {
                    arcGISServices.locator = AGSLocatorTask(url: geocoderURL)
                    print("Locator set to: \(geocoderURL)")
                }
                
                if let routeTaskURL = svcs.routeServiceURL, routeTaskURL != arcGISServices.routeTask.url {
                    arcGISServices.routeTask = AGSRouteTask(url: routeTaskURL)
                    print("Route Task set to: \(routeTaskURL)")
                }
            }
            
            self.loadBasemaps(portal:portal)
        }
    }
    
    // MARK: Basemaps
    /**
     Given an AGSPortal, load the basemaps group.
     */
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
    
    /**
     Given an AGSPortal, and the basemaps group, load the basemap items a page at a time.
     */
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
