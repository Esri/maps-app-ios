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
import ObjectiveC

// Intentionally blank structure. Additional Swift Files will extend this.
struct MapsAppNotifications {
    struct Names {
    }
}

extension MapsAppNotifications {
    private struct AssociatedKeys {
        static var notificationBlockReference = "notificationBlockReferences"
    }

    static internal func registerBlockHandler(blockHandler:NSObjectProtocol, forOwner owner:Any) {
        var blockHandlers = (objc_getAssociatedObject(owner, &AssociatedKeys.notificationBlockReference) as? [NSObjectProtocol]) ?? []
        blockHandlers.append(blockHandler)
        objc_setAssociatedObject(owner, &AssociatedKeys.notificationBlockReference, blockHandlers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    static func deregisterNotificationBlocks(forOwner owner:Any) {
        if let blockHandlersForOwner = objc_getAssociatedObject(owner, &AssociatedKeys.notificationBlockReference) as? [NSObjectProtocol] {
            for blockHandler in blockHandlersForOwner {
                print("Removing observer block \(blockHandler) on owner \(owner)")
                NotificationCenter.default.removeObserver(blockHandler)
            }
        }
    }
}
