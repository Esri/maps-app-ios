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
    
    @IBOutlet weak var controlsView: UIStackView!
    
    @IBOutlet weak var undoRedoView: UIView!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    @IBOutlet weak var keyboardSpacer: UIView!
    @IBOutlet weak var keyboardSpacerHeightConstraint: NSLayoutConstraint!
    var keyboardObservers:[NSObjectProtocol] = []
    
    var attributeAnchor:NSLayoutConstraint?
    var keyboardAnchor:NSLayoutConstraint?
    
    // MARK: Map feedback layers
    var graphicsOverlays:[String:AGSGraphicsOverlay] = [:]
    
    @IBAction func undoMode(_ sender: UIButton) {
        undoMode()
    }

    @IBAction func redoMode(_ sender: UIButton) {
        redoMode()
    }
    
    func undoMode() {
        modeIndex = max(0, modeIndex-1)
    }
    
    func redoMode() {
        modeIndex = min(modeIndex+1, modeHistory.count-1)
    }
    
    func setUndoRedoUI() {
        guard modeHistory.count > 1 else {
            undoRedoView.isHidden = true
            return
        }
        
        undoRedoView.isHidden = false
        
        undoButton.isEnabled = modeIndex > 0
        redoButton.isEnabled = modeIndex < modeHistory.count-1
    }
    
    var modeHistory:[MapViewMode] = []
    var modeIndex:Int = -1 {
        didSet {
            let newMode = modeHistory[modeIndex]
            mode = newMode
        }
    }
    
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
    
    var undoableMode:MapViewMode? {
        didSet {
            guard let undoableMode = undoableMode else {
                return
            }
            
            if !modeHistory.contains(undoableMode) {
//                if modeIndex < modeHistory.count-1 {
                    let numberOfRecordsToRemove = modeHistory.count-(modeIndex+1)
                    modeHistory.removeLast(numberOfRecordsToRemove)
//                }
                modeHistory.append(undoableMode)
                modeIndex = modeHistory.count-1
            }
            
            setUndoRedoUI()
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

        setupRouting()
        setupSearch()
        setupLocationDisplay()
        
        setupBasemapChangeHandler()
        setupCurrentItemChangeHandler()

        setupTouchEventsHandler()
        setupFeedbackPanelResizeHandler()

        setupMapViewAttributeBarTracking(activate: true)
        setupKeyboardTracking(activate: false)
        
        setUndoRedoUI()
        
        mode = .search
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        observeValueForPreferences(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    func setupMapViewAttributeBarTracking(activate:Bool) {
        attributeAnchor = controlsView.bottomAnchor.constraint(lessThanOrEqualTo: mapView.attributionTopAnchor, constant: -12)
        attributeAnchor?.isActive = true
    }
    
    func setupKeyboardTracking(activate:Bool) {
        keyboardAnchor = controlsView.bottomAnchor.constraint(equalTo: keyboardSpacer.topAnchor, constant: -12)
        keyboardAnchor?.isActive = activate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for notificationName:Notification.Name in [.UIKeyboardWillShow, .UIKeyboardWillHide] {
            keyboardObservers.append(NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { notification in
                self.setKeyboardSpacerFromKeyboardNotification(notification: notification)
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for observer in keyboardObservers {
            NotificationCenter.default.removeObserver(observer)
        }
        
        keyboardObservers.removeAll()
    }

    private func setKeyboardSpacerFromKeyboardNotification(notification:Notification) {
        if let userInfo = notification.userInfo,
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let rawCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uint32Value,
            let curve = UIViewAnimationCurve(rawValue: Int(rawCurve) << 16) {

            let endFrameInContext = view.convert(endFrame, to: self.view)
            let newHeight = view.bounds.maxY - endFrameInContext.minY

            UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState, curve.correspondingAnimationOption], animations: {
                if notification.name == .UIKeyboardWillShow {
                    self.attributeAnchor?.isActive = false
                    self.keyboardAnchor?.isActive = true
                } else if notification.name == .UIKeyboardWillHide {
                    self.attributeAnchor?.isActive = true
                    self.keyboardAnchor?.isActive = false
                }

                self.keyboardSpacerHeightConstraint.constant = newHeight
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

extension UIViewAnimationCurve {
    var correspondingAnimationOption:UIViewAnimationOptions {
        switch self {
        case .linear:
            return UIViewAnimationOptions.curveLinear
        case .easeIn:
            return UIViewAnimationOptions.curveEaseIn
        case .easeOut:
            return UIViewAnimationOptions.curveEaseOut
        case .easeInOut:
            return UIViewAnimationOptions.curveEaseInOut
        }
    }
}
