//
//  FeedbackViewController+Segues.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/30/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension FeedbackViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let from = self.childViewControllers.first
        self.swapChildVCs(from: from, to: segue.destination)
    }
    
    func swapChildVCs(from:UIViewController?, to:UIViewController) {
        // Code stolen from https://github.com/mluton/EmbeddedSwapping and modified for Swift 3
        // https://stackoverflow.com/questions/35014362/sizing-a-container-view-with-a-controller-of-dynamic-size-inside-a-scrollview helped a lot here
        //
        // This above snippets were also modified to make use of NSConstraints.
        to.view.translatesAutoresizingMaskIntoConstraints = false
        
        defer {
            // Regardless of how we add the child view, we need to place constraints between it and the container view.
            containerView.addConstraints([
                to.view.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1),
                to.view.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                to.view.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                to.view.topAnchor.constraint(equalTo: containerView.topAnchor)
            ])
        }
        
        guard let from = from else {
            // First time we're setting something. Just set it, don't transition to it.
            self.addChildViewController(to)
            containerView.addSubview(to.view)
            to.didMove(toParentViewController: self)
            
            return
        }
        
        // Moving from one view controller to another
        from.willMove(toParentViewController: nil)
        self.addChildViewController(to)

        // If duration > 0, this can crash if the user double-taps quickly on redo/undo. Need to ensure that
        // transitions are enqueued before animation can be reintroduced.
        self.transition(from: from, to: to, duration: 0, options: .transitionCrossDissolve, animations: nil) { finished in
            // After we've moved, complete our contract to the viewcontrollers so, and notify the MapsApp, since we might
            // be a different size than before and the MapView can consider that when zooming to a geometry.
            from.removeFromParentViewController()
            to.didMove(toParentViewController: self)
            
            NotificationCenter.default.post(name: FeedbackViewController.Notifications.Names.FeedbackPanelResizeCompleted, object: self, userInfo: nil)
        }
    }
}
