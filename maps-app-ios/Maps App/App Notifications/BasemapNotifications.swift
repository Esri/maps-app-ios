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

import ArcGIS

// MARK: External Notification API
extension MapsAppNotifications {
    static func observeBasemapChangedNotification(handler:@escaping ((AGSBasemap)->Void)) {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.CurrentBasemapChanged, object: mapsApp, queue: OperationQueue.main) { notification in
            // The user selected a new basemap. Let's show it in the MapView.
            if let newBasemap = notification.basemap {
                handler(newBasemap)
            }
        }
    }
}



// MARK: Internals
extension MapsAppNotifications {
    static func postCurrentBasemapChangedNotification(basemap:AGSPortalItem) {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.CurrentBasemapChanged, object: mapsApp, userInfo: [
            BasemapNotificationKeys.basemap : AGSBasemap(item: basemap)
        ])
    }
}

// MARK: Typed Notification Pattern
extension MapsAppNotifications.Names {
    static let CurrentBasemapChanged = NSNotification.Name("MapsAppCurrentBasemapChangedNotification")
}

extension Notification {
    var basemap:AGSBasemap? {
        get {
            if [MapsAppNotifications.Names.CurrentBasemapChanged].contains(self.name) {
                return self.userInfo?[BasemapNotificationKeys.basemap] as? AGSBasemap
            }
            return nil
        }
    }
}

// MARK: Internal Constants
fileprivate struct BasemapNotificationKeys {
    static let basemap = "basemapItem"
}
