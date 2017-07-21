//
//  MapViewController+MapViewMode.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/5/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

extension MapViewController {
    func updateMapViewForMode() {
        // Clear any results from the map.
        geocodeResultsOverlay.graphics.removeAllObjects()
        routeResultsOverlay.graphics.removeAllObjects()
        routeManeuversOverlay.graphics.removeAllObjects()
        
        var targetOverlay:AGSGraphicsOverlay?

        // Depending on the current mode, display contents in the map.
        switch mode {
        case .geocodeResult:
            targetOverlay = geocodeResultsOverlay
        case .routeResult:
            targetOverlay = routeResultsOverlay
        default:
            break
        }
        
        targetOverlay?.graphics.addObjects(from: mode.graphics)
        
        // And if need be, zoom the map appropriately.
        updateMapViewExtentForMode()
    }
    
    func updateMapViewExtentForMode() {
        if let targetExtent = mode.extent {
            mapView.setViewpointGeometry(targetExtent)
        }
    }
}
