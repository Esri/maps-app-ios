//
//  SearchNotificationHelper.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension MapsAppNotifications.Names {
    static let Search = Notification.Name("MapsAppSearchNotification")
    static let Suggest = Notification.Name("MapsAppSuggestNotification")
}

extension MapsAppNotifications {
    // MARK: Post Notifications
    static func postSearchNotification(searchBar:UISearchBar) {
        if let searchText = searchBar.text {
            let notification = Notification(name: MapsAppNotifications.Names.Search, object: nil, userInfo: [SearchNotifications.searchKey: searchText])
            NotificationCenter.default.post(notification)
        }
    }
    
    static func postSuggestNotification(searchBar:UISearchBar) {
        if let suggestText = searchBar.text, suggestText.characters.count > 0 {
            let notification = Notification(name: MapsAppNotifications.Names.Suggest, object: nil, userInfo: [SearchNotifications.searchKey: suggestText])
            NotificationCenter.default.post(notification)
        }
    }
}

extension Notification {
    var searchText:String? {
        get {
            if self.name == MapsAppNotifications.Names.Search || self.name == MapsAppNotifications.Names.Suggest {
                return self.userInfo?[SearchNotifications.searchKey] as? String
            }
            return nil
        }
    }
}

fileprivate struct SearchNotifications {
    static let searchKey = "searchText"
}
