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

extension MapViewController {
    func setupFeedbackPanelResizeHandler() {
        // When the feedback panel updates, we want to change the MapView's contentInset to avoid results appearing behind the
        // feedback panel.
        NotificationCenter.default.addObserver(forName: FeedbackViewController.Notifications.Names.FeedbackPanelResized, object: nil, queue: OperationQueue.main) { _ in
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
