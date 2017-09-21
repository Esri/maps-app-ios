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
    
    var routeManeuverLineSymbol:AGSSymbol {
        if let symbol = Bundle.main.agsSymbolFromJSON(resourceNamed: "DirectionsManeuverSymbol") {
            return symbol
        }
        
        print("Returning fallback maneuver symbol")
        let lineSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.orange.withAlphaComponent(0.9), width: 8)
        let backingSymbol = AGSSimpleLineSymbol(style: .solid, color: UIColor.white.withAlphaComponent(0.6), width: 13)
        return AGSCompositeSymbol(symbols: [backingSymbol, lineSymbol])
    }
}
