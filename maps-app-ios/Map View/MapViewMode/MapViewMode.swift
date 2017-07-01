//
//  MapViewMode.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/31/17.
//  Copyright © 2017 Esri. All rights reserved.
//
//  The MapView stores the current "mode". The mode determines

import ArcGIS

enum MapViewMode {
    case none
    case search
    case routeResult(AGSRoute)
    case geocodeResult(AGSGeocodeResult)
}

extension MapViewMode: CustomStringConvertible {
    var description: String {
        return simpleDescription
    }
    
    var simpleDescription: String {
        switch self {
        case .none:
            return "none"
        case .search:
            return "Search"
        case .routeResult:
            return "RouteResult"
        case .geocodeResult:
            return "GeocodeResult"
        }
    }
    
    var humanReadableDescription: String {
        switch self {
        case .geocodeResult(let result):
            return "Geocode \"\(result.label)\""
        case .routeResult(let route):
            return "Route \(route.routeName)".replacingOccurrences(of: " - ", with: " to ")
        default:
            return "\(self)"
        }
    }
    
    var shortHumanReadableDescription: String {
        switch self {
        case .geocodeResult:
            return "Geocode Result"
        case .routeResult:
            return "Route Result"
        default:
            return "\(self)"
        }
    }
}
