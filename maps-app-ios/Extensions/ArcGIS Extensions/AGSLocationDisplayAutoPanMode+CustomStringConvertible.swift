//
//  AGSLocationDisplayAutoPanMode+CustomStringConvertible.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/4/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension AGSLocationDisplayAutoPanMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .off:
            return "Off"
        case .recenter:
            return "Recenter"
        case .navigation:
            return "Navigation"
        case .compassNavigation:
            return "Compass Navigation"
        }
    }
}
