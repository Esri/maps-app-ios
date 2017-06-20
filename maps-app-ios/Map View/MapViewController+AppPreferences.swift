//
//  MapViewController+AppPreferences.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/5/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

fileprivate let navigationPropertyKey = #keyPath(AGSMapView.isNavigating)

extension MapViewController {
    func setupAppPreferences() {
        if let storedViewpoint = mapsAppPrefs.viewpoint {
            mapView.setViewpoint(storedViewpoint)
        }

        self.mapView.addObserver(self, forKeyPath: navigationPropertyKey, options: [.new], context: nil)
    }
    
    func observeValueForPreferences(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let target = object as? AGSMapView, keyPath == navigationPropertyKey, let navigating = change?[.newKey] as? Bool, navigating == false {
            mapsAppPrefs.viewpoint = target.currentViewpoint(with: .centerAndScale)
        }
    }
}
