//
//  CurrentItemNotifications.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/2/17.
//  Copyright © 2017 Esri. All rights reserved.
//

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
