//
//  MapViewController+RoutingResultsDisplay.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

private let routeResultLayerName = "routeResultsGraphicsLayer"
private let routeManeuverLayerName = "routeManeuverGraphicsLayer"

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

    var routeManeuversOverlay:AGSGraphicsOverlay {
        get {
            if self.graphicsOverlays[routeManeuverLayerName] == nil {
                self.routeManeuversOverlay = AGSGraphicsOverlay()
                self.routeManeuversOverlay.renderingMode = .static
            }
            
            return self.graphicsOverlays[routeManeuverLayerName]!
        }
        set {
            self.graphicsOverlays[routeManeuverLayerName] = newValue
        }
    }
    
    var routeStartSymbol:AGSSymbol {
        let symbol = AGSPictureMarkerSymbol(image: #imageLiteral(resourceName: "My Location Pin"))
        symbol.offsetY = (symbol.image?.size.height ?? 0)/2
        return symbol
    }
    
    var routeManeuverLineSymbol:AGSSymbol {
        if let path = Bundle.main.path(forResource: "DirectionsManeuverSymbol", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
                let json:NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let symbol = try AGSSymbol.fromJSON(json) as! AGSSymbol
                return symbol
            } catch {
                print("Error loading/parsing the JSON: \(error.localizedDescription)")
            }
        }
        
        print("Returning fallback maneuver symbol")
        let lineSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.orange.withAlphaComponent(0.9), width: 8)
        let backingSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.white.withAlphaComponent(0.6), width: 13)
        return AGSCompositeSymbol(symbols: [backingSymbol, lineSymbol])
    }
    
    func showDirections(route:AGSRoute?) {
        directionsViewController?.directions = route
    }
    
    var directionsViewController:DirectionsDisplayViewController? {
        return self.childViewControllers.filter({ $0 is DirectionsDisplayViewController }).first as? DirectionsDisplayViewController
    }
}
