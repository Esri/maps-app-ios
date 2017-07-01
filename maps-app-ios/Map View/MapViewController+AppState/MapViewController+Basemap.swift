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
            }
        })
    }
}
