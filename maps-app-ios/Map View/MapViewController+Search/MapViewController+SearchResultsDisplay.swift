//
//  MapViewController+SearchResultsDisplay.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

private let geocodeResultLayerName = "geocodeResultsGraphicsLayer"

extension MapViewController {
    
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
        suggestionDisplayViewController?.suggestions = suggestions
    }
    
    var suggestionDisplayViewController: SuggestionDisplayViewController? {
        return self.childViewControllers.filter({ $0 is SuggestionDisplayViewController }).first as? SuggestionDisplayViewController
    }
}
