//
//  AppAGSServices+Search.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/13/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension AppAGSServices {

    // MARK: ArcGIS Operations
    func search(searchText:String) {
        let params = AGSGeocodeParameters()
        if let center = mapsAppContext.currentMapView?.currentViewpoint(with: .centerAndScale)?.targetGeometry as? AGSPoint {
            params.preferredSearchLocation = center
        }
        
        mapsAppContext.validToShowSuggestions = false
        
        locator.geocode(withSearchText: searchText, parameters: params) { results, error in
            guard error == nil else {
                print("Error performing search! \(error!.localizedDescription)")
                return
            }
            
            if let result = results?.first {
                MapsAppNotifications.postSearchCompletedNotification(result: result)
            } else {
                mapsApp.showDefaultAlert(message: "\"\(searchText)\"\nreturned no results.")
            }
        }
    }
    
    func search(suggestion:AGSSuggestResult) {
        let params = AGSGeocodeParameters()
        if let center = mapsAppContext.currentMapView?.currentViewpoint(with: .centerAndScale)?.targetGeometry as? AGSPoint {
            params.preferredSearchLocation = center
        }
        
        mapsAppContext.validToShowSuggestions = false
        locator.geocode(with: suggestion, parameters: params) { results, error in
            guard error == nil else {
                print("Error performing search from suggestion \(suggestion.label)! \(error!.localizedDescription)")
                return
            }
            
            if let result = results?.first {
                MapsAppNotifications.postSearchCompletedNotification(result: result)
            } else {
                mapsApp.showDefaultAlert(message: "Autocomplete for\n\"\(suggestion.label)\"\nreturned no results.")
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
            
            MapsAppNotifications.postSearchCompletedNotification(result: result)
        }
    }
    
    func getSuggestions(forSearchText searchText:String) {
        locator.load { error in
            guard error == nil else {
                print("Error loading locator: \(error!.localizedDescription)")
                return
            }
            
            guard self.locator.locatorInfo?.supportsSuggestions == true else {
                return
            }
            
            guard !searchText.isEmpty else {
                mapsAppContext.validToShowSuggestions = false
                return
            }
            
            let params = AGSSuggestParameters()
            if let center = mapsAppContext.currentMapView?.currentViewpoint(with: .centerAndScale)?.targetGeometry as? AGSPoint {
                params.preferredSearchLocation = center
            }
            
            mapsAppContext.validToShowSuggestions = true
            
            self.locator.suggest(withSearchText: searchText, parameters: params) { suggestions, error in
                guard error == nil else {
                    print("Error getting suggestions for \"\(searchText)\": \(error!.localizedDescription)")
                    return
                }
                
                guard let suggestions = suggestions else {
                    return
                }
                
                MapsAppNotifications.postSearchSuggestionsAvailableNotification(suggestions: suggestions)
            }
        }
    }
}
