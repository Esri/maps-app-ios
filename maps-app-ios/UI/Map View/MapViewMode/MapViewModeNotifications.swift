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

extension MapsAppNotifications.Names {
    static let MapViewModeChanged = NSNotification.Name("MapViewModeChangedNotification")
}

extension MapsAppNotifications {
    static func observeModeChangeNotification(owner:Any, modeChangeHandler:@escaping (MapViewMode,MapViewMode)->Void) {
        let ref = NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.MapViewModeChanged, object: nil, queue: OperationQueue.main) { notification in
            if let newValue = notification.newMapViewMode, let oldValue = notification.oldMapViewMode {
                modeChangeHandler(oldValue, newValue)
            }
        }
        MapsAppNotifications.registerBlockHandler(blockHandler: ref, forOwner: owner)
    }
    
    static func postModeChangeNotification(oldMode:MapViewMode, newMode:MapViewMode) {
        let userInfo = [NSKeyValueChangeKey.oldKey:oldMode, NSKeyValueChangeKey.newKey:newMode]
        NotificationCenter.default.post(name: MapsAppNotifications.Names.MapViewModeChanged, object: nil, userInfo: userInfo)
    }
}

extension Notification {
    var oldMapViewMode:MapViewMode? {
        if self.name == MapsAppNotifications.Names.MapViewModeChanged {
            return self.userInfo?[NSKeyValueChangeKey.oldKey] as? MapViewMode
        }
        return nil
    }

    var newMapViewMode:MapViewMode? {
        if self.name == MapsAppNotifications.Names.MapViewModeChanged {
            return self.userInfo?[NSKeyValueChangeKey.newKey] as? MapViewMode
        }
        return nil
    }
}

