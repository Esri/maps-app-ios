//
//  MapViewController+Route.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/1/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapViewController {

    
    // MARK: Routing Operations
    func route(to:AGSStop) {
        let from = self.mapView.routeStop(inSpatialReference: self.mapView.spatialReference!)
        route(from: from, to: to)
    }

    func route(from:AGSStop, to:AGSStop) {

        if let params = defaultRouteParameters {

            // To make best use of the service, we will base our request off the service's default parameters.
            params.setStops([from,to])

            self.routeTask.solveRoute(with: params) { (result, error) in
                guard error == nil else {
                    print("Error solving route between \(from) and \(to): \(error!.localizedDescription)")
                    return
                }
                
                guard let route = result?.routes.first else {
                    print("Route result unexpectedly empty between \(from) and \(to)")
                    return
                }
                
                self.mode = .routeResult(route)
                
                let startGraphic = AGSGraphic(geometry: route.stops.first?.geometry, symbol: self.routeStartSymbol, attributes: nil)
                let routeGraphic = AGSGraphic(geometry: route.routeGeometry, symbol: self.mode.symbol, attributes: nil)
                
                self.routeResultsOverlay.graphics.removeAllObjects()
                self.routeResultsOverlay.graphics.addObjects(from: [routeGraphic, startGraphic])
            }
            
        } else {

            // If those parameters haven't been loaded yet, then let's load them first and try again.
            loadDefaultParametersThenRoute(from: from, to: to)
            
        }
    }

    
    
    // MARK: Convenience methods
    func route(to:AGSStopProvider) {
        route(to: to.routeStop(inSpatialReference: self.mapView.spatialReference!))
    }
    
    func route(from:AGSStopProvider, to:AGSStopProvider) {
        route(from: from.routeStop(inSpatialReference: self.mapView.spatialReference!),
              to: to.routeStop(inSpatialReference: self.mapView.spatialReference!))
    }

    
    
    //MARK: Default parameter fetch logic
    private func loadDefaultParametersThenRoute(from:AGSStop, to:AGSStop) {
        
        routeTask.loadCachedDefaultParameters() { (params, error) in
            defer {
                if let defaultParams = self.defaultRouteParameters {
                    defaultParams.outputSpatialReference = self.mapView.spatialReference
                    defaultParams.returnStops = true
                    defaultParams.returnDirections = true
                    defaultParams.returnRoutes = true
                }

                self.route(from: from, to: to)
            }
            
            guard error == nil else {
                print("Error getting default parameters: \(error!.localizedDescription)")
                self.defaultRouteParameters = AGSRouteParameters()
                return
            }
            
            guard params != nil else {
                print("No default parameters available.")
                self.defaultRouteParameters = AGSRouteParameters()
                return
            }
            
            self.defaultRouteParameters = params
        }

    }
}
