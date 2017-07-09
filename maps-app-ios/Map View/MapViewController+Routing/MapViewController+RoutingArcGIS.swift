//
//  MapViewController+RoutingArcGIS.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/1/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapViewController {

    //MARK: ArcGIS Components
    var routeTask:AGSRouteTask {
        return mapsAppState.routeTask
    }
    
    // MARK: Get directions
    func route(from:AGSStop, to:AGSStop) {
        warnAboutLoginIfLoggedOut(message: "Getting directions requires a login and consumes credits.", continueHandler: {
            self.requestRoute(from: from, to: to)
        })
    }
    
    func requestRoute(from:AGSStop, to:AGSStop) {
        
        SVProgressHUD.show(withStatus: "Getting directions…")
        
        routeTask.defaultRouteParameters() { defaultParams, error in
            guard error == nil else {
                SVProgressHUD.showError(withStatus: "Error getting default parameters")
                print("Error getting default parameters: \(error!.localizedDescription)")
                return
            }
            
            guard let params = defaultParams else {
                SVProgressHUD.showError(withStatus: "No default parameters available.")
                print("No default parameters available.")
                return
            }

            params.outputSpatialReference = self.mapView.spatialReference
            params.returnStops = true
            params.returnDirections = true
            params.returnRoutes = true

            // To make best use of the service, we will base our request off the service's default parameters.
            params.setStops([from,to])

            self.routeTask.solveRoute(with: params) { result, error in
                guard error == nil else {
                    SVProgressHUD.showError(withStatus: "Unable to solve route.")
                    print("Error solving route between \(from) and \(to): \(error!.localizedDescription)")
                    return
                }
                
                guard let route = result?.routes.first else {
                    SVProgressHUD.showError(withStatus: "Route result unexpectedly empty")
                    print("Route result unexpectedly empty between \(from) and \(to)")
                    return
                }
                
                SVProgressHUD.dismiss()
                
                self.mode = .routeResult(route)
                
                self.showDirections(route: route)
            }
        }

    }
    
    
    // MARK: Convenience methods
    func route(to:AGSStop) {
        let from = self.mapView.routeStop(inSpatialReference: self.mapView.spatialReference!)
        route(from: from, to: to)
    }
    
    func route(to:MapsAppStopProvider) {
        route(to: to.routeStop(inSpatialReference: self.mapView.spatialReference!))
    }
    
    func route(from:MapsAppStopProvider, to:MapsAppStopProvider) {
        route(from: from.routeStop(inSpatialReference: self.mapView.spatialReference!),
              to: to.routeStop(inSpatialReference: self.mapView.spatialReference!))
    }
}
