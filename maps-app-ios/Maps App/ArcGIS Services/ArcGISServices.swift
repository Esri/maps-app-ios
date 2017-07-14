//
//  ArcGISServices.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/13/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

class ArcGISServices {
    // MARK: ArcGIS Services
    var locator = AGSLocatorTask(url: AppSettings.worldGeocoderURL)
    var routeTask = AGSRouteTask(url: AppSettings.worldRoutingServiceURL)
    var defaultRouteParameters: AGSRouteParameters?    
}
