//
//  FeedbackViewController+FeedbackMode.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

extension FeedbackViewController {
    var mode:FeedbackMode {
        get {
            return mapViewController?.mode ?? .none
        }
        set {
            self.mapViewController?.mode = newValue
        }
    }
    
    func setupModeChangeListener() {
        MapsAppNotifications.observeModeChangeNotification { oldValue, newValue in
            self.setUIForMode(mode: newValue, previousMode: oldValue)
        }
    }
    
    func setUIForMode(mode:FeedbackMode, previousMode:FeedbackMode) {
        guard mode != .none else {
            return
        }
        
        if !(mode ~== previousMode) {
            self.performSegue(withIdentifier: "\(mode.segueName)", sender: nil)
        }
        
        switch mode {
        case .geocodeResult(let result):
            self.geocodeResultViewController?.result = result
        case .routeResult(let result):
            self.routeResultViewController?.routeResult = result
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segue = segue as? FeedbackContentsSegue {
            segue.feedbackViewController = self
        }
    }
}
