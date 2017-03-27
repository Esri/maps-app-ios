//
//  MapViewController+Routing+Config.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

private let routeResultLayerName = "routeResultsGraphicsLayer"

extension MapViewController {
    //MARK: AGS Components
    var routeTask:AGSRouteTask {
        return mapsApp.routeTask
    }
    
    var defaultRouteParameters:AGSRouteParameters? {
        get {
            return mapsApp.defaultRouteParameters
        }
        set {
            mapsApp.defaultRouteParameters = newValue
        }
    }
    
    
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
        let symbol = AGSPictureMarkerSymbol(image: #imageLiteral(resourceName: "Blue Pin"))
        symbol.offsetY = #imageLiteral(resourceName: "Blue Pin").size.height/2
        return symbol
    }
    
    
    // MARK: Setup
    func setupRouting() {
        self.mapView.graphicsOverlays.add(self.routeResultsOverlay)
        
        NotificationCenter.default.addObserver(forName: RouteNotifications.Names.Route, object: nil, queue: nil) { (notification) in
            guard let to = notification.routeTo else {
                print("No destination provided in the Route Notification!")
                return
            }
            
            if let from = notification.routeFrom {
                self.route(from: from, to: to)
            } else {
                self.route(to: to)
            }
        }
    }
}
