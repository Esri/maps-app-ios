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

extension ArcGISServices {

    // MARK: Geocode (Point from Search Text)
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
    
    // MARK: Reverse Geocode (Address from Point)
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
    
    // MARK: Suggest (Suggestion from Search Text)
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

    // MARK: Geocode (Point from Suggestion)
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
}
