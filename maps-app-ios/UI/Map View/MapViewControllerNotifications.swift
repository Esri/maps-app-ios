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
import ArcGIS

extension MapsAppNotifications {
    static func observeMapViewExtentNotifications(owner:Any, resetExtentHandler:@escaping ()->Void, focusOnExtentHandler:@escaping (AGSEnvelope)->Void) {
        let ref = NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.mapViewResetExtentForMode, object: nil, queue: OperationQueue.main) {
            notification in
            resetExtentHandler()
        }
        MapsAppNotifications.registerBlockHandler(blockHandler: ref, forOwner: owner)
        
        let focusRef = NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.mapViewReqestFocusOnExtent, object: nil, queue: OperationQueue.main) {
            notification in
            if let extent = notification.requestedExtent {
                focusOnExtentHandler(extent)
            }
        }
        MapsAppNotifications.registerBlockHandler(blockHandler: focusRef, forOwner: owner)
    }
}

extension MapsAppNotifications {
    static func postMapViewResetExtentForModeNotification() {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.mapViewResetExtentForMode, object: nil)
    }
    
    static func postMapViewRequestFocusOnExtentNotification(extent: AGSEnvelope) {
        let userInfo = [MapViewNotificationKeys.extent:extent]
        NotificationCenter.default.post(name: MapsAppNotifications.Names.mapViewReqestFocusOnExtent, object: nil, userInfo: userInfo)
    }
}

extension MapsAppNotifications.Names {
    static let mapViewResetExtentForMode = NSNotification.Name("MapViewResetExtentForModeNotification")
    static let mapViewReqestFocusOnExtent = NSNotification.Name("MapViewRequestFocusOnExtentNotification")
}

extension Notification {
    var requestedExtent:AGSEnvelope? {
        guard self.name == MapsAppNotifications.Names.mapViewReqestFocusOnExtent else {
            return nil
        }
        
        return self.userInfo?[MapViewNotificationKeys.extent] as? AGSEnvelope
    }
}

fileprivate struct MapViewNotificationKeys {
    static let extent = "extent"
}
