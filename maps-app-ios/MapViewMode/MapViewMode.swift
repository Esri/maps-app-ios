//
//  MapViewMode.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/31/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

infix operator ~==

enum MapViewMode: Equatable, CustomStringConvertible {
    case none
    case search
    case routeResult(AGSRoute)
    case geocodeResult(AGSGeocodeResult)
    
    var description: String {
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
    
    static func ==(lhs:MapViewMode, rhs:MapViewMode) -> Bool {
        switch (lhs,rhs) {
        case (.none,.none), (.search,.search):
            return true
        case let (.routeResult(lResult),.routeResult(rResult)):
            return lResult.isEqual(rResult)
        case let (.geocodeResult(lResult), .geocodeResult(rResult)):
            return lResult.isEqual(rResult)
        default:
            return false
        }
    }
    
    static func ~==(lhs:MapViewMode, rhs:MapViewMode) -> Bool {
        switch (lhs,rhs) {
        case (.none,.none), (.search,.search), (.routeResult,.routeResult), (.geocodeResult, .geocodeResult):
            return true
        default:
            return false
        }
    }
}
