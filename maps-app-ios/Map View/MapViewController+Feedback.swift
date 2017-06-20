//
//  MapViewController+Feedback.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension MapViewController {
    var feedbackViewController:FeedbackViewController? {
        return self.childViewControllers.filter({ $0 is FeedbackViewController }).first as? FeedbackViewController
    }
    
    func setupFeedbackPanelResizeHandler() {
        // When the feedback panel updates, we want to change the MapView's contentInset to avoid results appearing behind the
        // feedback panel.
        NotificationCenter.default.addObserver(forName: FeedbackViewController.Notifications.Names.FeedbackPanelResizeCompleted, object: nil, queue: nil) { _ in
            if let feedbackView = self.feedbackViewController?.view {
                let feedbackFrame = feedbackView.convert(feedbackView.frame, to: self.mapView)
                
                let topInset = feedbackFrame.maxY
                self.mapView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)

                self.updateMapViewExtentForMode()
            }
        }
    }
}
