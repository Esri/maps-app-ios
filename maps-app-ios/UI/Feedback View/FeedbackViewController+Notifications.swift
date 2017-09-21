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

import Foundation

// MARK: External Notification API
extension MapsAppNotifications {
    // MARK: Register Listeners
    static func observeFeedbackPanelResizedNotifications(owner:Any, handler:@escaping (FeedbackViewController)->Void) {
        let ref = NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.feedbackPanelResized, object: nil, queue: OperationQueue.main) { notification in
            if let vc = notification.feedbackViewController {
                handler(vc)
            }
        }
        MapsAppNotifications.registerBlockHandler(blockHandler: ref, forOwner: owner)
    }
}

// MARK: Internals
extension MapsAppNotifications {
    static func postFeedbackPanelResizedNotification(panel:FeedbackViewController) {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.feedbackPanelResized, object: panel,
                                        userInfo: nil)
    }
}

// MARK: Typed Notification Pattern
extension MapsAppNotifications.Names {
    static let feedbackPanelResized = Notification.Name("FeedbackPanelResized")
}

extension Notification {
    var feedbackViewController:FeedbackViewController? {
        guard self.name == MapsAppNotifications.Names.feedbackPanelResized else {
            return nil
        }

        return self.object as? FeedbackViewController
    }
}

// MARK: Internal Constants
fileprivate struct FeedbackPanelNotifications {
    static let viewControllerKey = "feedbackPanelViewController"
}
