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
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.CurrentItemChanged, object: nil, queue: nil) { _ in
            // The app's current item has changed. Let's show the new item in the MapView.
            self.displayCurrentItem()
        }
    }
    
    func displayCurrentItem() {
        if let item = mapsAppState.currentItem, item.type == .webMap {
            let map = AGSMap(item: item)
            map.load() { error in
                guard error == nil else {
                    var errorMessage:String!
                    if let nsError = error as NSError?, nsError.code == 7009 {
                        errorMessage = "\(nsError.localizedFailureReason ?? fallbackWebMapVersionErrorMessage).\n\nTo correct this, open the WebMap in the ArcGIS Online (or ArcGIS Portal) Map Viewer and re-save it."
                    } else {
                        errorMessage = "\(error!.localizedDescription)"
                    }

                    self.showError(title: "Error opening map", message: errorMessage)
                    return
                }

                self.mapView.map = map
                
                self.enforceInitialExtent(mapView: self.mapView)
            }
        }
    }
    
    func enforceInitialExtent(mapView:AGSMapView) {
        // If LocationDisplay is on and set to autopan, that will override setting the map's extent to the web map.
        // In our case we want to explicitly override that, as we always want to show the WebMap we just picked.
        // This will automatically set the autoPanMode to .off
        mapView.map?.load() { error in
            guard error == nil else {
                print("Error opening the map \(error!.localizedDescription)")
                return
            }
            
            guard let ext = self.mapView.map?.item?.extent,
                self.mapView.locationDisplay.started,
                self.mapView.locationDisplay.autoPanMode != .off else {
                return
            }
            
            self.mapView.setViewpoint(AGSViewpoint(targetExtent: ext))
        }
    }
}
