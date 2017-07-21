//
//  MapViewController+CurrentItem.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/5/17.
//  Copyright © 2017 Esri. All rights reserved.
//

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
