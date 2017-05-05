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
    
    var graphicsOverlays:[String:AGSGraphicsOverlay] = [:]
    
    var mode:MapViewMode = .none {
        didSet {
            updateMapForMode()

            // Announce that the mode has changed (the Feedback Panel UI listens to this)
            MapsAppNotifications.postModeChangeNotification(oldMode: oldValue, newMode: mode)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.map = mapsAppPrefs.map ?? AGSMap(basemapType: .topographicVector, latitude: 40.7128, longitude: -74.0059, levelOfDetail: 10)

        setupRouting()
        setupSearch()
        setupAppPreferences()
        setupLocationDisplay()
        setupTouch()

        mode = .search
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.PortalItemChanged, object: nil, queue: nil) { notification in
            if let item = mapsApp.currentItem, item.type == .webMap {
                let map = AGSMap(item: item)
                map.load() { error in
                    guard error == nil else {
                        print("Error opening the map! \(error!.localizedDescription)")
                        return
                    }

                    // Possible bug around having LocationDisplay on.
                    if let ext = map.item?.extent, self.mapView.locationDisplay.started {
                        defer {
                            self.mapView.setViewpoint(AGSViewpoint(targetExtent: ext))
                        }
                    }
                    
                    self.mapView.map = map
                }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        observeValueForPreferences(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    func updateMapForMode() {
        // Update the map
        switch mode {
        case .geocodeResult:
            geocodeResultsOverlay.graphics.removeAllObjects()
            if let graphic = mode.graphic {
                geocodeResultsOverlay.graphics.add(graphic)
            }
        case .routeResult:
            routeResultsOverlay.graphics.removeAllObjects()
            if let graphic = mode.graphic {
                routeResultsOverlay.graphics.add(graphic)
            }
        case .none, .search:
            routeResultsOverlay.graphics.removeAllObjects()
            geocodeResultsOverlay.graphics.removeAllObjects()
        }

        if let targetExtent = mode.extent {
            mapView.setViewpointGeometry(targetExtent)
        }
    }
}
