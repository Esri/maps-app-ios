//
//  MapViewMode+CustomStringConvertible.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/1/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

extension MapViewMode: CustomStringConvertible {
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
}
