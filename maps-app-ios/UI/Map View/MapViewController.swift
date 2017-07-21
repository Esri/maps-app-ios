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
    
    @IBOutlet weak var controlsView: UIStackView!
    @IBOutlet weak var gpsButton:UIButton!
    
    @IBOutlet weak var prevNextModeView: UIView!
    @IBOutlet weak var prevModeButton: UIButton!
    @IBOutlet weak var nextModeButton: UIButton!
    
    // MARK: Keyboard Tracking
    @IBOutlet weak var keyboardSpacer: UIView!
    @IBOutlet weak var keyboardSpacerHeightConstraint: NSLayoutConstraint!
    var keyboardObservers:[NSObjectProtocol] = []
    
    var attributeAnchor:NSLayoutConstraint?
    var keyboardAnchor:NSLayoutConstraint?
    
    // MARK: Map feedback layers
    var graphicsOverlays:[String:AGSGraphicsOverlay] = [:]
    
    // MARK: MapView Mode
    var mode:MapViewMode = .none {
        didSet {
            switch mode {
            case .routeResult, .geocodeResult:
                undoableMode = mode
            default:
                break
            }

            updateMapViewForMode()

            // Announce that the mode has changed (the Feedback Panel UI listens to this)
            MapsAppNotifications.postModeChangeNotification(oldMode: oldValue, newMode: mode)
        }
    }
    
    // MARK: Mode History
    var modeHistory:[MapViewMode] = []
    var modeIndex:Int = -1 {
        didSet {
            let newMode = modeHistory[modeIndex]
            mode = newMode
        }
    }
    
    var undoableMode:MapViewMode? {
        didSet {
            updateModeHistory(newMode: undoableMode)
            
            setModeHistoryUI()
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
        
        // Read any preferences and set up hooks to automatically store preferences.
        setupAppPreferences()

        // Set up some UI.
        setupRouting()
        setupSearch()
        setupLocationDisplay()
        
        // Set up handlers for events that could change the map.
        setupBasemapChangeHandler()
        setupCurrentItemChangeHandler()

        // Set up some other UX related handlers.
        setupTouchEventsHandler()
        setupFeedbackPanelResizeHandler()
        setupMapViewAttributeBarTracking(activate: true)
        setupKeyboardTracking(activate: false)
        
        // Setup the mode history behaviour.
        setModeHistoryUI()
        
        SVProgressHUD.setContainerView(self.view)
        SVProgressHUD.setDefaultMaskType(.black)
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.MapViewResetExtentForMode, object: nil, queue: OperationQueue.main) { notification in
            self.updateMapViewExtentForMode()
        }
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.MapViewReqestFocusOnExtent, object: nil, queue: OperationQueue.main) { notification in
            if let requestedExtent = notification.requestedExtent {
                self.mapView.setViewpoint(AGSViewpoint(targetExtent: requestedExtent), completion: nil)
            }
        }
        
        mapsAppContext.currentMapView = mapView
        
        // And start off in Search Mode.
        mode = .search
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Start caring about the keyboard display when the view appears.
        activateKeyboardTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop caring about the keyboard display when the view disappears.
        deactivateKeyboardTracking()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Pass KVO through to the helper function provided by the MapViewController+AppPreferences extension. Won't need this with Swift 4 👯‍♂️!!
        observeValueForPreferences(forKeyPath: keyPath, of: object, change: change, context: context)
    }
}
