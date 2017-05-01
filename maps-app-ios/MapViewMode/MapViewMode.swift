//
//  MapViewMode.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/31/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

enum MapViewMode  {
    case none
    case search
    case routeResult(AGSRoute)
    case geocodeResult(AGSGeocodeResult)
}
