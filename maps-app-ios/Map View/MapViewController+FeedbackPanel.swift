//
//  MapViewController+FeedbackPanel.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension MapViewController {
    func setupFeedbackPanelResizeHandler() {
        // When the feedback panel updates, we want to change the MapView's contentInset to avoid results appearing behind the
        // feedback panel.
        NotificationCenter.default.addObserver(forName: FeedbackViewController.Notifications.Names.FeedbackPanelResizeCompleted, object: nil, queue: OperationQueue.main) { _ in
            if let feedbackView = self.feedbackViewController?.view {
                // The Feedback View has resized itself. Let's update the MapView contentInsets to reflect this.
                let feedbackFrame = feedbackView.convert(feedbackView.frame, to: self.mapView)
                
                self.mapView.contentInset.top = feedbackFrame.maxY

                self.updateMapViewExtentForMode()
            }
        }
    }
    
    var feedbackViewController:FeedbackViewController? {
        return self.childViewControllers.filter({ $0 is FeedbackViewController }).first as? FeedbackViewController
    }
}
