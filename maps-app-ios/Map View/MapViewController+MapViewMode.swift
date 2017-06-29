//
//  MapViewController+MapViewMode.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/5/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension MapViewController {
    func updateMapViewForMode() {
        // Update the map
        
        geocodeResultsOverlay.graphics.removeAllObjects()
        routeResultsOverlay.graphics.removeAllObjects()
        routeManeuversOverlay.graphics.removeAllObjects()

        switch mode {
        case .geocodeResult:
            geocodeResultsOverlay.graphics.addObjects(from: mode.graphics)
        case .routeResult:
            routeResultsOverlay.graphics.addObjects(from: mode.graphics)
        default:
            break
        }
        
        updateMapViewExtentForMode()
    }
    
    func updateMapViewExtentForMode() {
        if let targetExtent = mode.extent {
            mapView.setViewpointGeometry(targetExtent)
        }
    }
}
