//
//  SearchNotificationHelper.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

extension MapsAppNotifications.Names {
    static let RequestSearch = Notification.Name("MapsAppSearchNotification")
    static let RequestSearchFromSuggestion = Notification.Name("MapsAppSearchFromSuggestionNotification")
    
    static let RequestSuggestions = Notification.Name("MapsAppGetSuggestionsNotification")
    
    static let SearchCompleted = Notification.Name("MapsAppSearchCompletedNotification")
}

extension MapsAppNotifications {
    // MARK: Notification listener setup shortcut
    static func observeSearchNotifications(searchNotificationHander:@escaping ((_ searchText:String)->Void),
                                           suggestNotificationHandler:((_ searchText:String)->Void)?,
                                           searchFromSuggestionNotificationHandler:((_ suggestion:AGSSuggestResult)->Void)?) {
        // Listen for notifications from the UI to trigger search and suggest operations.
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.RequestSearch, object: nil, queue: nil) { notification in
            if let searchText = notification.searchText {
                searchNotificationHander(searchText)
            }
        }
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.RequestSuggestions, object: nil, queue: nil) { notification in
            if let searchText = notification.searchText {
                suggestNotificationHandler?(searchText)
            }
        }
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.RequestSearchFromSuggestion, object: nil, queue: nil) { notification in
            if let suggestion = notification.suggestion {
                searchFromSuggestionNotificationHandler?(suggestion)
            }
        }
    }

    // MARK: Post Notifications shortcuts
    static func postSearchNotification(searchBar:UISearchBar) {
        // Notify that we'd like to do a search based off a SearchBar's text.
        if let searchText = searchBar.text {
            NotificationCenter.default.post(name: MapsAppNotifications.Names.RequestSearch, object: nil,
                                            userInfo: [SearchNotificationKeys.search: searchText])
        }
    }
    
    static func postSearchFromSuggestionNotification(suggestion:AGSSuggestResult) {
        // Notify that we'd like to do a search based off an AGSSuggestResult.
        NotificationCenter.default.post(name: MapsAppNotifications.Names.RequestSearchFromSuggestion, object: nil,
                                        userInfo: [SearchNotificationKeys.suggestion: suggestion])
    }
    
    static func postSuggestNotification(searchBar:UISearchBar) {
        // Notify that we'd like to get search suggestions based off a SearchBar's text.
        if let suggestText = searchBar.text, suggestText.characters.count > 0 {
            NotificationCenter.default.post(name: MapsAppNotifications.Names.RequestSuggestions, object: nil,
                                            userInfo: [SearchNotificationKeys.search: suggestText])
        }
    }
    
    static func postSearchCompletedNotification() {
        // Notify that we're no longer searching and it's time to hide any related UI (e.g. an autocomplete
        NotificationCenter.default.post(name: MapsAppNotifications.Names.SearchCompleted, object: nil)
    }
    
}

extension Notification {
    var searchText:String? {
        get {
            if [MapsAppNotifications.Names.RequestSearch, MapsAppNotifications.Names.RequestSuggestions].contains(self.name) {
                return self.userInfo?[SearchNotificationKeys.search] as? String
            }
            return nil
        }
    }
    
    var suggestion:AGSSuggestResult? {
        get {
            if self.name == MapsAppNotifications.Names.RequestSearchFromSuggestion {
                return self.userInfo?[SearchNotificationKeys.suggestion] as? AGSSuggestResult
            }
            return nil
        }
    }
}

fileprivate struct SearchNotificationKeys {
    static let search = "searchText"
    static let suggestion = "suggestion"
}
