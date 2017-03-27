//
//  SearchNotificationHelper.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

struct SearchNotifications {
    struct Names {
        static let Search = Notification.Name("AGSSearchNotification")
        static let Suggest = Notification.Name("AGSSuggestNotification")
    }
    
    fileprivate static let searchKey = "searchText"
}

extension NotificationCenter {
    // MARK: Post Notifications
    func postSearchNotification(searchBar:UISearchBar) {
        if let searchText = searchBar.text {
            let notification = Notification(name: SearchNotifications.Names.Search, object: nil, userInfo: [SearchNotifications.searchKey: searchText])
            NotificationCenter.default.post(notification)
        }
    }
    
    func postSuggestNotification(searchBar:UISearchBar) {
        if let suggestText = searchBar.text, suggestText.characters.count > 0 {
            let notification = Notification(name: SearchNotifications.Names.Suggest, object: nil, userInfo: [SearchNotifications.searchKey: suggestText])
            NotificationCenter.default.post(notification)
        }
    }
}

extension Notification {
    var searchText:String? {
        get {
            if self.name == SearchNotifications.Names.Search || self.name == SearchNotifications.Names.Suggest {
                return self.userInfo?[SearchNotifications.searchKey] as? String
            }
            return nil
        }
    }
}
