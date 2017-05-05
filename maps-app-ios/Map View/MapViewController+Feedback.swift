//
//  MapViewController+Feedback.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//

extension MapViewController {
    var feedbackViewController:FeedbackViewController? {
        return self.childViewControllers.filter({ $0 is FeedbackViewController }).first as? FeedbackViewController
    }
}
