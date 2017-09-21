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

protocol MapsAppStopProvider {
    // Provide a method to return an AGSStop in the appropriate spatial reference
    func routeStop(inSpatialReference sr:AGSSpatialReference) -> AGSStop
}

extension AGSPoint : MapsAppStopProvider {
    func routeStop(inSpatialReference sr: AGSSpatialReference) -> AGSStop {
        let stopGeometry = (AGSGeometryEngine.projectGeometry(self, to: sr) as? AGSPoint) ?? AGSPoint.zeroPoint(spatialReference: sr)
        return AGSStop(point:stopGeometry)
    }
}

extension AGSGeocodeResult : MapsAppStopProvider {
    func routeStop(inSpatialReference sr: AGSSpatialReference) -> AGSStop {
        // If we want to route to an AGSGeocodeResult, let's try the routeLocation first, else fall back to the displayLocation
        let stop = (self.routeLocation ?? self.displayLocation ?? AGSPoint.zeroPoint(spatialReference: sr)).routeStop(inSpatialReference: sr)
        stop.name = self.label
        return stop
    }
}

extension AGSMapView : MapsAppStopProvider {
    func routeStop(inSpatialReference sr: AGSSpatialReference = AGSSpatialReference.wgs84()) -> AGSStop {
        // For a MapView, if the LocationDisplay is started, route to that
        if let mapLocation = self.locationDisplay.location?.position, self.locationDisplay.started {
            let stop = mapLocation.routeStop(inSpatialReference: sr)
            stop.name = "Your Location"
            return stop
        }
        
        // Else route to the center of the map view
        if let stop = self.visibleArea?.extent.center.routeStop(inSpatialReference: sr) {
            stop.name = "Center of map"
            return stop
        }

        // Else route to 0,0. This is not good practice, but should be obvious enough that something's gone wrong.
        let pt = AGSPoint(x: 0, y: 0, spatialReference: sr)
        let stop = pt.routeStop(inSpatialReference: sr)
        stop.name = "Unknown start point"
        return stop
    }
}

// MARK: Fallback Point Constructor
extension AGSPoint {
    static func zeroPoint(spatialReference sr:AGSSpatialReference) -> AGSPoint {
        return AGSPoint(x: 0, y: 0, z: 0, m: 0, spatialReference: sr)
    }
}
