//
//  MapViewController+Basemap.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/19/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapViewController {
    func setupBasemapChangeHandler() {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.NewBasemap, object: nil, queue: nil, using: { notification in
            // The user selected a new basemap. Let's show it in the MapView.
            if let newBasemap = notification.basemap {
                self.mapView.map?.basemap = newBasemap
                
                newBasemap.load(){ error in
                    guard error == nil else {
                        print("Error loading basemap: \(error!.localizedDescription)")
                        return
                    }
                    
                    if let firstLayer = newBasemap.baseLayers.firstObject as? AGSLayer {
                        firstLayer.load() { error in
                            guard error == nil else {
                                print("Error loading basemap layer: \(error!.localizedDescription)")
                                return
                            }

                            self.mapView.map?.maxScale = firstLayer.maxScale
                            print("Set map maxScale to \(firstLayer.maxScale)")
                        }
                    }
                }
            }
        })
    }
}
