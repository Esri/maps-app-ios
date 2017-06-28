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
        
        self.mapView.graphicsOverlays.add(self.routeManeuversOverlay)
        
        MapsAppNotifications.observeManeuverFocusNotifications { maneuver in
            if let targetExtent = maneuver.geometry?.extent {
                let builder = targetExtent.toBuilder()
                builder.expand(byFactor: 1.2)
                if maneuver.length < 200 {
                    builder.expand(byFactor: 8)
                }
                self.mapView.setViewpoint(AGSViewpoint(targetExtent: builder.toGeometry()), completion: nil)
                
                self.routeManeuversOverlay.graphics.removeAllObjects()
                var maneuverSymbol:AGSSymbol?
                switch maneuver.maneuverType {
                case .depart, .stop:
                    let stopSymbol = AGSSimpleMarkerSymbol(style: .circle, color: UIColor.orange, size: 20)
                    stopSymbol.outline = AGSSimpleLineSymbol(style: .solid, color: UIColor.white, width: 2)
                    maneuverSymbol = stopSymbol
                default:
                    maneuverSymbol = self.routeManeuverLineSymbol
                }
                let maneuverGraphic = AGSGraphic(geometry: maneuver.geometry, symbol: maneuverSymbol, attributes: nil)
                self.routeManeuversOverlay.graphics.add(maneuverGraphic)
            }
        }
    }
}
