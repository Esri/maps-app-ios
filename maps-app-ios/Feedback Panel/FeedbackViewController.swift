//
//  FeedbackViewController.swift
//  VCTesting
//
//  Created by Nicholas Furness on 3/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

typealias FeedbackMode = MapViewMode

class FeedbackViewController : UIViewController {

    @IBOutlet weak var containerView: UIVisualEffectView!
    
    var mapViewController:MapViewController? {
        return self.parent as? MapViewController
    }

    var mode:FeedbackMode {
        get {
            return mapViewController?.mode ?? .none
        }
        set {
            self.mapViewController?.mode = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupModeChangeListener()
    }
    
    func setupModeChangeListener() {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.MapViewModeChanged, object: nil, queue: nil) { notification in
            if let newValue = notification.newMapViewMode, let oldValue = notification.oldMapViewMode {
                guard newValue != .none else {
                    return
                }
                
                if !(newValue ~== oldValue) {
                    self.performSegue(withIdentifier: "\(self.mode)Segue", sender: nil)
                }
                
                switch newValue {
                case .geocodeResult(let result):
                    self.geocodeResultViewController?.result = result
                case .routeResult(let result):
                    self.routeResultViewController?.routeResult = result
                default:
                    break
                }
            }
        }
    }

    @IBAction func returnToSearch(_ segue:UIStoryboardSegue) {
        self.mode = .search
    }
}
