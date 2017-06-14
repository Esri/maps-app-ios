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
//        guard suggestions.count > 0 else {
//            print("No suggestions!")
//            return
//        }
        
        for (index, suggestion) in suggestions.enumerated() {
            print("\(index + 1): \(suggestion.label)")
        }
        
        suggestionDisplayViewController?.suggestions = suggestions
    }
    
    var suggestionDisplayViewController: SuggestionDisplayViewController? {
        return self.childViewControllers.filter({
            $0 is SuggestionDisplayViewController
        }).first as? SuggestionDisplayViewController
    }
}
