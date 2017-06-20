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
            if let newBasemap = notification.basemap {
                self.mapView.map?.basemap = newBasemap
            }
        })
    }
}
