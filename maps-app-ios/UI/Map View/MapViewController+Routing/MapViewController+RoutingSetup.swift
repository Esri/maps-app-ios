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

extension MapViewController {
    func setupRouting() {
        self.mapView.graphicsOverlays.add(self.routeResultsOverlay)

        MapsAppNotifications.observeRouteSolvedNotification { result in
            self.mode = .routeResult(result)
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
