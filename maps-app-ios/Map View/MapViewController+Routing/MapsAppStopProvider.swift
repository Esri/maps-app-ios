//
//  MapsAppStopProvider.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/1/17.
//  Copyright © 2017 Esri. All rights reserved.
//
//  Provide an AGSStop object suitable for passing to the Routing service.


import ArcGIS

protocol MapsAppStopProvider {
    // Provide a method to return an AGSStop in the appropriate spatial reference
    func routeStop(inSpatialReference sr:AGSSpatialReference) -> AGSStop
}

extension AGSPoint : MapsAppStopProvider {
    func routeStop(inSpatialReference sr: AGSSpatialReference) -> AGSStop {
        return AGSStop(point:AGSGeometryEngine.projectGeometry(self, to: sr) as! AGSPoint)
    }
}

extension AGSGeocodeResult : MapsAppStopProvider {
    func routeStop(inSpatialReference sr: AGSSpatialReference) -> AGSStop {
        // If we want to route to an AGSGeocodeResult, let's try the routeLocation first, else fall back to the displayLocation
        let stop = (self.routeLocation ?? self.displayLocation!).routeStop(inSpatialReference: sr)
        stop.name = self.label
        return stop
    }
}

extension AGSMapView : MapsAppStopProvider {
    func routeStop(inSpatialReference sr: AGSSpatialReference) -> AGSStop {
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
