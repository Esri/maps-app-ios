//
//  SearchNotificationHelper.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension MapsAppNotifications.Names {
    static let SearchRequested = Notification.Name("MapsAppSearchNotification")
    static let SuggestRequested = Notification.Name("MapsAppSuggestNotification")
}

extension MapsAppNotifications {
    // MARK: Post Notifications
    static func postSearchNotification(searchBar:UISearchBar) {
        if let searchText = searchBar.text {
            NotificationCenter.default.post(name: MapsAppNotifications.Names.SearchRequested, object: nil,
                                            userInfo: [SearchNotificationKeys.search: searchText])
        }
    }
    
    static func postSuggestNotification(searchBar:UISearchBar) {
        if let suggestText = searchBar.text, suggestText.characters.count > 0 {
            NotificationCenter.default.post(name: MapsAppNotifications.Names.SuggestRequested, object: nil,
                                            userInfo: [SearchNotificationKeys.search: suggestText])
        }
    }
    
    static func observeSearchNotifications(searchNotificationHander:@escaping ((_ searchText:String)->Void), suggestNotificationHandler:((_ searchText:String)->Void)?) {
        // Listen for notifications from the UI to trigger search and suggest operations.
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.SearchRequested, object: nil, queue: nil) { notification in
            if let searchText = notification.searchText {
                searchNotificationHander(searchText)
            }
        }
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.SuggestRequested, object: nil, queue: nil) { notification in
            if let searchText = notification.searchText {
                suggestNotificationHandler?(searchText)
            }
        }
    }
}

extension Notification {
    var searchText:String? {
        get {
            if [MapsAppNotifications.Names.SearchRequested, MapsAppNotifications.Names.SuggestRequested].contains(self.name) {
                return self.userInfo?[SearchNotificationKeys.search] as? String
            }
            return nil
        }
    }
}

fileprivate struct SearchNotificationKeys {
    static let search = "searchText"
}
