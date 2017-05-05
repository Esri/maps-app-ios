//
//  MapViewController+Feedback.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

extension MapViewController {
    var feedbackViewController:FeedbackViewController? {
        get {
            return self.childViewControllers.filter({ $0 is FeedbackViewController }).first as? FeedbackViewController
        }
    }
}
