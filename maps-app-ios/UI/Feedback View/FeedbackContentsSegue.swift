// Copyright 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

class FeedbackContentsSegue: UIStoryboardSegue {
    // Set in the FeedbackViewController's prepareForSegue()
    var feedbackViewController:FeedbackViewController!
    
    override func perform() {
        let from = feedbackViewController.children.first
        let to = self.destination
        swapChildVCs(from: from, to: to)
    }
    
    func swapChildVCs(from:UIViewController?, to:UIViewController) {
        // Code derived from https://github.com/mluton/EmbeddedSwapping and modified for Swift 3
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
            feedbackViewController.addChild(to)
            feedbackViewController.containerView.addSubview(to.view)
            to.didMove(toParent: feedbackViewController)
            
            return
        }
        
        // Switch from one view controller to another.
        from.willMove(toParent: nil)
        feedbackViewController.addChild(to)
        
        // If duration > 0, this can crash if the user double-taps quickly on redo/undo. Need to ensure that
        // transitions are enqueued before animation can be reintroduced.
        feedbackViewController.transition(from: from, to: to, duration: 0, options: .transitionCrossDissolve, animations: nil) { finished in
            // After we've moved, complete our contract to the viewcontrollers so, and notify the MapsApp, since we might
            // be a different size than before and the MapView can consider that when zooming to a geometry.
            from.removeFromParent()
            to.didMove(toParent: self.feedbackViewController)
            
            MapsAppNotifications.postFeedbackPanelResizedNotification(panel: self.feedbackViewController)
        }
    }
}
