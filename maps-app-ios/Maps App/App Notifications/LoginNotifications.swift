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
    // MARK: Register Listeners
    static func observeLoginStateNotifications(owner:Any, loginHandler:((AGSPortalUser)->Void)?, logoutHandler:(()->Void)?) {
        if let loginHandler = loginHandler {
            let ref = NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.appSignedIn, object: mapsApp, queue: OperationQueue.main) { notification in
                if let signedInUser = notification.signedInUser {
                    loginHandler(signedInUser)
                }
            }
            MapsAppNotifications.registerBlockHandler(blockHandler: ref, forOwner: owner)
        }
        
        if let logoutHandler = logoutHandler {
            let ref = NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.appSignedOut, object: mapsApp, queue: OperationQueue.main) { notification in
                logoutHandler()
            }
            MapsAppNotifications.registerBlockHandler(blockHandler: ref, forOwner: owner)
        }
    }
}



// MARK: Internals
extension MapsAppNotifications {
    static func postSignedInNotification(user:AGSPortalUser) {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.appSignedIn, object: mapsApp,
                                        userInfo: [LoginNotifications.userKey:user])
    }

    static func postSignedOutNotification() {
        NotificationCenter.default.post(name: MapsAppNotifications.Names.appSignedOut, object: mapsApp)
    }

}

// MARK: Typed Notification Pattern
extension MapsAppNotifications.Names {
    static let appSignedIn = Notification.Name("MapsAppSignedInNotification")
    static let appSignedOut = Notification.Name("MapsAppSignedOutNotification")
}

extension Notification {
    var signedInUser:AGSPortalUser? {
        guard self.name == MapsAppNotifications.Names.appSignedIn else {
            return nil
        }

        return self.userInfo?[LoginNotifications.userKey] as? AGSPortalUser
    }
}

// MARK: Internal Constants
fileprivate struct LoginNotifications {
    static let userKey = "user"
}
