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
        
        if to is RouteResultViewController {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80)
        } else {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        }
        
        // Code stolen from https://github.com/mluton/EmbeddedSwapping and modified for Swift 3
        to.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        
        guard let from = from else {
            // First time we're setting something. Just set it, don't transition to it.
            self.addChildViewController(to)
            self.containerView.addSubview(to.view)
            to.didMove(toParentViewController: self)
            return
        }
        
        // Moving from one thing to another
        from.willMove(toParentViewController: nil)
        self.addChildViewController(to)
        self.transition(from: from, to: to, duration: 0.3, options: .transitionCrossDissolve, animations: nil) { (finished) in
            from.removeFromParentViewController()
            to.didMove(toParentViewController: self)
        }
    }
}
