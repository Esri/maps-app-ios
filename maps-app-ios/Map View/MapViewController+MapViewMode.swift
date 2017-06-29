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
        switch mode {
        case .geocodeResult:
            geocodeResultsOverlay.graphics.removeAllObjects()
            if let graphic = mode.graphic {
                geocodeResultsOverlay.graphics.add(graphic)
            }
        case .routeResult:
            routeResultsOverlay.graphics.removeAllObjects()
            routeManeuversOverlay.graphics.removeAllObjects()
            if let graphic = mode.graphic {
                routeResultsOverlay.graphics.add(graphic)
            }
        case .none, .search:
            routeResultsOverlay.graphics.removeAllObjects()
            routeManeuversOverlay.graphics.removeAllObjects()
            geocodeResultsOverlay.graphics.removeAllObjects()
        }
        
        updateMapViewExtentForMode()
    }
    
    func updateMapViewExtentForMode() {
        if let targetExtent = mode.extent {
            mapView.setViewpointGeometry(targetExtent)
        }
    }
}
