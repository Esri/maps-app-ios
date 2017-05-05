//
//  MapViewController+Touch.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/5/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapViewController: AGSGeoViewTouchDelegate {
    func setupTouch() {
        mapView.touchDelegate = self
    }

    func geoView(_ geoView: AGSGeoView, didEndLongPressAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        self.getAddressForPoint(point: mapPoint)
    }
}
