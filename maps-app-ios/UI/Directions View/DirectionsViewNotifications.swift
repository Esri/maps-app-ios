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

extension MapsAppNotifications.Names {
    static let ManeuverFocus = Notification.Name("DirectionsViewManeuverFocusNotification")
}

extension MapsAppNotifications {
    static func postManeuverFocusNotification(maneuver:AGSDirectionManeuver) {
        var userInfo:[AnyHashable:Any] = [:]
        
        userInfo[DirectionsViewNotificationKeys.maneuver] = maneuver
        
        NotificationCenter.default.post(name: MapsAppNotifications.Names.ManeuverFocus, object: nil, userInfo: userInfo)
    }
    
    static func observeManeuverFocusNotifications(maneuverFocusNotificationHandler:@escaping ((_ maneuver:AGSDirectionManeuver)->Void)) {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.ManeuverFocus, object: nil, queue: nil) { notification in
            guard let maneuver = notification.directionManeuver else {
                print("No maneuver object found for Maneuver Focus Notification!")
                return
            }
            
            maneuverFocusNotificationHandler(maneuver)
        }
    }
}

extension Notification {
    var directionManeuver:AGSDirectionManeuver? {
        if self.name == MapsAppNotifications.Names.ManeuverFocus {
            return self.userInfo?[DirectionsViewNotificationKeys.maneuver] as? AGSDirectionManeuver
        }
        return nil
    }
}

fileprivate struct DirectionsViewNotificationKeys {
    static let maneuver = "directionManeuver"
}
