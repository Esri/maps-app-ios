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
        
        // Moving from one thing to another
        from.willMove(toParentViewController: nil)
        self.addChildViewController(to)
        self.transition(from: from, to: to, duration: 0.3, options: .transitionCrossDissolve, animations: nil) { finished in
            from.removeFromParentViewController()
            to.didMove(toParentViewController: self)
            
            NotificationCenter.default.post(name: FeedbackViewController.Notifications.Names.FeedbackPanelResizeCompleted, object: self, userInfo: nil)
        }
    }
}
