//
//  MapViewController+SearchSetup.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/5/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

extension MapViewController {
    func setupSearch() {
        // Add a layer to the map to display search results
        mapView.graphicsOverlays.add(geocodeResultsOverlay)
        
        MapsAppNotifications.observeSearchNotifications(searchResultHandler: { result in
            if let result = result {
                self.mode = .geocodeResult(result)
            }
        }, suggestionsAvailableHandler: nil)
    }
}
