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

fileprivate let fallbackWebMapVersionErrorMessage = "The WebMap version is pre 2.0"

extension MapViewController {
    func setupCurrentItemChangeHandler() {
        MapsAppNotifications.observeCurrentItemChanged() {
            // The app's current item has changed. Let's show the new item in the MapView.
            self.displayCurrentItem()
        }
    }

    fileprivate func displayCurrentItem() {
        if let item = mapsAppContext.currentItem, item.type == .webMap {
            let map = AGSMap(item: item)
            map.load() { error in
                guard error == nil else {
                    var errorMessage:String!
                    if let nsError = error as NSError?, nsError.code == AGSErrorCode.mappingWebmapNotSupported.rawValue {
                        errorMessage = "\(nsError.localizedFailureReason ?? fallbackWebMapVersionErrorMessage).\n\nTo correct this, open the WebMap in the ArcGIS Online (or ArcGIS Portal) Map Viewer and re-save it."
                    } else {
                        errorMessage = "\(error!.localizedDescription)"
                    }

                    mapsApp.showError(title: "Error opening map", message: errorMessage)
                    return
                }

                self.mapView.map = map
                
                self.enforceInitialExtent(mapView: self.mapView)
            }
        }
    }
    
    fileprivate func enforceInitialExtent(mapView:AGSMapView) {
        // If LocationDisplay is on and set to autopan, that will override setting the map's extent to the web map.
        // In our case we want to explicitly override that, as we always want to show the WebMap we just picked.
        // This will automatically set the autoPanMode to .off
        guard let ext = self.mapView.map?.item?.extent,
            self.mapView.locationDisplay.started,
            self.mapView.locationDisplay.autoPanMode != .off else {
            return
        }
        
        self.mapView.setViewpoint(AGSViewpoint(targetExtent: ext))
    }
}
