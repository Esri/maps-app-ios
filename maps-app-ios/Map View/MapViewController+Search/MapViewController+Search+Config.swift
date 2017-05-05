//
//  MapViewController+Search+Config.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

private let geocodeResultLayerName = "geocodeResultsGraphicsLayer"

extension MapViewController {
    
    
    // MARK: AGS Components
    var locator:AGSLocatorTask {
        return mapsApp.locator
    }
    
    
    // MARK: Map Feedback
    var geocodeResultsOverlay:AGSGraphicsOverlay {
        get {
            if graphicsOverlays[geocodeResultLayerName] == nil {
                self.geocodeResultsOverlay = AGSGraphicsOverlay()
            }
            
            return graphicsOverlays[geocodeResultLayerName]!
        }
        set {
            graphicsOverlays[geocodeResultLayerName] = newValue
        }
    }
    
    
    // MARK: UI Feedback
    func showSuggestions(suggestions:[AGSSuggestResult]) {
        guard suggestions.count > 0 else {
            print("No suggestions!")
            return
        }
        
        for (index, suggestion) in suggestions.enumerated() {
            print("\(index + 1): \(suggestion.label)")
        }
    }
    
    
    // MARK: Setup
    func setupSearch() {
        mapView.graphicsOverlays.add(geocodeResultsOverlay)
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.Search, object: nil, queue: nil) { (notification) in
            if let searchText = notification.searchText {
                self.search(searchText:searchText)
            }
        }
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.Suggest, object: nil, queue: nil) { (notification) in
            if let searchText = notification.searchText {
                self.getSuggestions(forSearchText: searchText)
            }
        }
    }
    
    
}

