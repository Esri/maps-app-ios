//
//  FeedbackContentsSegue.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

class FeedbackContentsSegue: UIStoryboardSegue {
    // Set in the FeedbackViewController's prepareForSegue()
    var feedbackViewController:FeedbackViewController!
    
    override func perform() {
        let from = feedbackViewController.childViewControllers.first
        let to = self.destination
        swapChildVCs(from: from, to: to)
    }
    
    func swapChildVCs(from:UIViewController?, to:UIViewController) {
        // Code stolen from https://github.com/mluton/EmbeddedSwapping and modified for Swift 3
        // https://stackoverflow.com/questions/35014362/sizing-a-container-view-with-a-controller-of-dynamic-size-inside-a-scrollview helped a lot here
        //
        // This above snippets were also modified to make use of NSConstraints.
        to.view.translatesAutoresizingMaskIntoConstraints = false
        
        defer {
            if let containerView = feedbackViewController.containerView {
                // Regardless of how we add the child view, we need to place constraints between it and the container view.
                containerView.addConstraints([
                    to.view.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1),
                    to.view.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                    to.view.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                    to.view.topAnchor.constraint(equalTo: containerView.topAnchor)
                    ])
            }
        }
        
        guard let from = from else {
            // First time we're installing a contained view controller, just add it, don't transition to it.
            feedbackViewController.addChildViewController(to)
            feedbackViewController.containerView.addSubview(to.view)
            to.didMove(toParentViewController: feedbackViewController)
            
            return
        }
        
        // Switch from one view controller to another.
        from.willMove(toParentViewController: nil)
        feedbackViewController.addChildViewController(to)
        
        // If duration > 0, this can crash if the user double-taps quickly on redo/undo. Need to ensure that
        // transitions are enqueued before animation can be reintroduced.
        feedbackViewController.transition(from: from, to: to, duration: 0, options: .transitionCrossDissolve, animations: nil) { finished in
            // After we've moved, complete our contract to the viewcontrollers so, and notify the MapsApp, since we might
            // be a different size than before and the MapView can consider that when zooming to a geometry.
            from.removeFromParentViewController()
            to.didMove(toParentViewController: self.feedbackViewController)
            
            NotificationCenter.default.post(name: FeedbackViewController.Notifications.Names.FeedbackPanelResized,
                                            object: self.feedbackViewController,
                                            userInfo: nil)
        }
    }
}
