//
//  MapViewMode+Equatable.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/1/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

infix operator ~==

extension MapViewMode: Equatable {
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
