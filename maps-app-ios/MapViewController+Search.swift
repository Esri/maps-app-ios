//
//  MapViewController+Search.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapViewController {
    
    // MARK: ArcGIS Operations
    // Suggestions
    func getSuggestions(forSearchText searchText:String) {
        if locator.locatorInfo?.supportsSuggestions == false {
            return
        }

        locator.suggest(withSearchText: searchText) { (results, error) in
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

    // Geocode
    func search(searchText:String) {
        locator.geocode(withSearchText: searchText) { (results, error) in
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
    
    // Reverse Geocode
    func getAddressForPoint(point:AGSPoint) {
        locator.reverseGeocode(withLocation: point) { (results, error) in
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

}
