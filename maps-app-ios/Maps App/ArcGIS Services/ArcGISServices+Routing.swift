// Copyright 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import ArcGIS

extension ArcGISServices {
    
    // MARK: Directions from A to B
    func route(from:AGSStop, to:AGSStop) {
        mapsApp.requestConfirmationIfSignedOut(explanation: "Getting directions requires a login and consumes credits.", continueHandler: {
            self.requestRoute(from: from, to: to)
        })
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
    
    // MARK: ArcGIS Route Task
    private func requestRoute(from:AGSStop, to:AGSStop) {
        
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

                mapsAppContext.routeResult = result
                MapsAppNotifications.postRouteSolvedNotification(result: routeResult)
            }
        }
        
    }
}
