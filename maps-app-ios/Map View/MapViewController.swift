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
    @IBOutlet weak var controlsView: RoundedView!
    
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
        if let modeUndoManager = undoManager {
            print("About to undo \(modeUndoManager.undoActionName)")
            modeUndoManager.undo()
            setUndoRedoUI()
        }
    }

    @IBAction func redoMode(_ sender: UIButton) {
        if let modeUndoManager = undoManager {
            print("About to redo \(modeUndoManager.redoActionName)")
            modeUndoManager.redo()
            setUndoRedoUI()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
        
        if let modeUndoManager = undoManager {
            NotificationCenter.default.addObserver(forName: Notification.Name.NSUndoManagerDidCloseUndoGroup, object: modeUndoManager, queue: nil) { notification in
                self.setUndoRedoUI()
            }
        }
    }
    
    
    func setUndoRedoUI() {
        if let modeUndoManager = undoManager {
            undoRedoView.isHidden = !(modeUndoManager.canUndo || modeUndoManager.canRedo)
            undoButton.isEnabled = modeUndoManager.canUndo
            redoButton.isEnabled = modeUndoManager.canRedo
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
    
    var undoableMode:MapViewMode = .none {
        didSet {
            if let modeUndoManager = undoManager {
                guard oldValue != .none else {
                    return
                }
//                guard !modeUndoManager.isUndoing && !modeUndoManager.isRedoing else {
//                    return
//                }
                
                // Register an undo action.
                modeUndoManager.registerUndo(withTarget: self) { [undoMode = oldValue] (target) in
                    target.mode = undoMode
                }
                if !modeUndoManager.isUndoing {
                    modeUndoManager.setActionName("\(undoableMode.humanReadableDescription)")
                }
            }
        }
    }
    
    var modeHistory:[MapViewMode] = []
    var modeIndex:Int = -1
    
//    var modeUndoManager = UndoManager()
    
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
        
        undoRedoView.isHidden = true
        
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
        
        resignFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
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
