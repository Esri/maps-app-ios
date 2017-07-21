//
//  MapViewController+LocationDisplay.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapViewController {
    func setupLocationDisplay() {
        mapView.locationDisplay.start() { error in
            if let error = error {
                mapsApp.showDefaultAlert(title: "Unable to start GPS", message: error.localizedDescription)
            }
        }
        
        mapView.locationDisplay.autoPanModeChangedHandler = { newAutoPanMode in
            print("New autoPanMode: \(newAutoPanMode)")
            self.gpsButton.setImage(self.mapView.locationDisplay.getImage(), for: .normal)
        }
    }
    
    @IBAction func nextGPSMode(_ sender: Any) {
        mapView.locationDisplay.autoPanMode = mapView.locationDisplay.autoPanMode.next()
    }
}
