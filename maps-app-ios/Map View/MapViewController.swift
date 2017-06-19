//
//  MapViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/24/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

class MapViewController: UIViewController {
    
    // MARK: UI Outlets
    @IBOutlet weak var mapView: AGSMapView!
    @IBOutlet weak var gpsButton:UIButton!
    
    // MARK: Map feedback layers
    var graphicsOverlays:[String:AGSGraphicsOverlay] = [:]
    
    // MARK: MapView Mode
    var mode:MapViewMode = .none {
        didSet {
            updateMapViewForMode()

            // Announce that the mode has changed (the Feedback Panel UI listens to this)
            MapsAppNotifications.postModeChangeNotification(oldMode: oldValue, newMode: mode)
        }
    }
    
    // MARK: View initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let storedMap = mapsAppPrefs.map {
            mapView.map = storedMap
        } else {
            // Default fallback
            mapView.map = AGSMap(basemapType: .topographicVector, latitude: 40.7128, longitude: -74.0059, levelOfDetail: 10)
        }

        setupAppPreferences()
        setupTouch()
        setupRouting()
        setupSearch()
        setupLocationDisplay()
        
        setupCurrentItemWatcher()

        setupFeedbackPanelWatcher()
        
        setupBasemapChangeListener()

        mode = .search
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        observeValueForPreferences(forKeyPath: keyPath, of: object, change: change, context: context)
    }
}
