//
//  MapViewController+ArcGISSearch.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapViewController {
    
    // MARK: ArcGIS Task
    var locator:AGSLocatorTask {
        return mapsAppState.locator
    }
    
    // MARK: ArcGIS Operations
    func search(searchText:String) {
        let params = AGSGeocodeParameters()
        if let mapVP = self.mapView.currentViewpoint(with: .centerAndScale), let center = mapVP.targetGeometry as? AGSPoint {
            params.preferredSearchLocation = center
        }

        locator.geocode(withSearchText: searchText, parameters: params) { results, error in
            guard error == nil else {
                print("Error performing search! \(error!.localizedDescription)")
                return
            }
            
            if let result = results?.first {
                self.mode = .geocodeResult(result)
            } else {
                self.showDefaultAlert(message: "\"\(searchText)\"\nreturned no results.")
            }
        }
    }
    
    func search(suggestion:AGSSuggestResult) {
        let params = AGSGeocodeParameters()
        if let mapVP = self.mapView.currentViewpoint(with: .centerAndScale), let center = mapVP.targetGeometry as? AGSPoint {
            params.preferredSearchLocation = center
        }
        
        locator.geocode(with: suggestion) { results, error in
            guard error == nil else {
                print("Error performing search from suggestion \(suggestion.label)! \(error!.localizedDescription)")
                return
            }
            
            if let result = results?.first {
                self.mode = .geocodeResult(result)
            } else {
                self.showDefaultAlert(message: "Autocomplete for\n\"\(suggestion.label)\"\nreturned no results.")
            }
        }
    }
    
    func getAddressForPoint(point:AGSPoint) {
        locator.reverseGeocode(withLocation: point) { results, error in
            guard error == nil else {
                print("Error reverse geocoding from \(point): \(error!.localizedDescription)")
                return
            }
            
            guard let result = results?.first else {
                return
            }
            
            self.mode = .geocodeResult(result)
        }
    }

    func getSuggestions(forSearchText searchText:String) {
        if locator.locatorInfo?.supportsSuggestions == false {
            return
        }
        
        let params = AGSSuggestParameters()
        if let mapVP = self.mapView.currentViewpoint(with: .centerAndScale), let center = mapVP.targetGeometry as? AGSPoint {
            params.preferredSearchLocation = center
        }
        
        locator.suggest(withSearchText: searchText, parameters: params) { results, error in
            guard error == nil else {
                print("Error getting suggestions for \"\(searchText)\": \(error!.localizedDescription)")
                return
            }
            
            guard let results = results else {
                return
            }
            
            self.showSuggestions(suggestions: results)
        }
    }
}
