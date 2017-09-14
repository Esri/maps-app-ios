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
    static func observeCurrentItemChanged(handler:@escaping ()->Void) {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.CurrentItemChanged, object: mapsApp, queue: OperationQueue.main) { _ in
            handler()
        }
    }

    static func observeCurrentFolderChanged(handler:@escaping ()->Void) {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.CurrentFolderChanged, object: mapsApp, queue: OperationQueue.main) { _ in
            handler()
        }
    }
}



// MARK: Internals
extension MapsAppNotifications {
    static func postCurrentItemChangeNotification() {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.CurrentItemChanged, object: mapsApp, userInfo: nil)
    }
    
    static func postCurrentFolderChangeNotification() {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.CurrentFolderChanged, object: mapsApp, userInfo: nil)
    }
}

// MARK: Typed Notification Pattern
extension MapsAppNotifications.Names {
    static let CurrentItemChanged = NSNotification.Name("MapsAppCurrentItemChangedNotification")
    static let CurrentFolderChanged = NSNotification.Name("MapsAppCurrentFolderChangedNotification")
}
