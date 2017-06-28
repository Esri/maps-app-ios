//
//  MapViewController+RoutingSetup.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/5/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapViewController {
    func setupRouting() {
        self.mapView.graphicsOverlays.add(self.routeResultsOverlay)

        MapsAppNotifications.observeRoutingNotifications() { fromStop, toStop in
            if let fromStop = fromStop {
                self.route(from: fromStop, to: toStop)
            } else {
                self.route(to: toStop)
            }
        }
        
        MapsAppNotifications.observeManeuverFocusNotifications { maneuver in
            if let targetExtent = maneuver.geometry?.extent {
                let builder = targetExtent.toBuilder()
                builder.expand(byFactor: 1.2)
                self.mapView.setViewpoint(AGSViewpoint(targetExtent: builder.toGeometry()), completion: nil)
            }
        }
    }
}
