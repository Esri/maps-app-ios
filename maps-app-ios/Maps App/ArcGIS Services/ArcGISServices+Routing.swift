//
//  ArcGISServices+Routing.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/13/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension ArcGISServices {
    // MARK: Get directions
    func route(from:AGSStop, to:AGSStop) {
        mapsApp.requestConfirmationIfLoggedOut(explanation: "Getting directions requires a login and consumes credits.", continueHandler: {
            self.requestRoute(from: from, to: to)
        })
    }
    
    func requestRoute(from:AGSStop, to:AGSStop) {
        
        mapsApp.showProgressFeedback(status: "Getting directions…")
        
        routeTask.defaultRouteParameters() { defaultParams, error in
            guard error == nil else {
                mapsApp.showProgressError(errorMessage: "Error getting default parameters")
                print("Error getting default parameters: \(error!.localizedDescription)")
                return
            }
            
            // To make best use of the service, we will base our request off the service's default parameters.
            guard let params = defaultParams else {
                mapsApp.showProgressError(errorMessage: "No default parameters available.")
                print("No default parameters available.")
                return
            }
            
            params.returnStops = true
            params.returnDirections = true
            params.returnRoutes = true
            params.setStops([from,to])
            
            if let outSR = mapsAppContext.currentMapView?.spatialReference {
                params.outputSpatialReference = outSR
            }

            self.routeTask.solveRoute(with: params) { result, error in
                guard error == nil else {
                    mapsApp.showProgressError(errorMessage: "Unable to solve route.")
                    print("Error solving route between \(from) and \(to): \(error!.localizedDescription)")
                    return
                }
                
                guard let routeResult = result?.routes.first else {
                    mapsApp.showProgressError(errorMessage: "Route result unexpectedly empty")
                    print("Route result unexpectedly empty between \(from) and \(to)")
                    return
                }
                
                mapsApp.dismissProgressFeedback()

                MapsAppNotifications.postRouteSolvedNotification(result: routeResult)
            }
        }
        
    }
    
    
    // MARK: Convenience methods
    func route(to:AGSStop) {
        if let from = mapsAppContext.currentMapView?.routeStop() {
            route(from: from, to: to)
        }
    }
    
    func route(to:MapsAppStopProvider) {
        route(to: to.routeStop(inSpatialReference: mapsAppContext.currentMapView?.spatialReference ?? AGSSpatialReference.wgs84()))
    }
}
