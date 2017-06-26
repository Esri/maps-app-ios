//
//  MapViewController+RoutingResultsDisplay.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

private let routeResultLayerName = "routeResultsGraphicsLayer"

extension MapViewController {

    // MARK: Map Feedback
    var routeResultsOverlay:AGSGraphicsOverlay {
        get {
            if self.graphicsOverlays[routeResultLayerName] == nil {
                self.routeResultsOverlay = AGSGraphicsOverlay()
            }
            
            return self.graphicsOverlays[routeResultLayerName]!
        }
        set {
            self.graphicsOverlays[routeResultLayerName] = newValue
        }
    }
    
    var routeStartSymbol:AGSSymbol {
        let symbol = AGSPictureMarkerSymbol(image: #imageLiteral(resourceName: "My Location Pin"))
        symbol.offsetY = (symbol.image?.size.height ?? 0)/2
        return symbol
    }
    
}
