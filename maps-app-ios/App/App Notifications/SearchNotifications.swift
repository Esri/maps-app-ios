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
    static let SearchRequested = Notification.Name("MapsAppSearchRequestedNotification")
    static let SearchRequestedFromSuggestion = Notification.Name("MapsAppSearchRequestedFromSuggestionNotification")
    static let SearchSuggestionsRequested = Notification.Name("MapsAppSearchSuggestionsRequestedNotification")
    static let SearchCompleted = Notification.Name("MapsAppSearchCompletedNotification")
}

extension MapsAppNotifications {
    // MARK: Notification listener setup shortcut
    static func observeSearchNotifications(searchNotificationHander:@escaping ((_ searchText:String)->Void),
                                           suggestNotificationHandler:((_ searchText:String)->Void)?,
                                           searchFromSuggestionNotificationHandler:((_ suggestion:AGSSuggestResult)->Void)?) {
        
        // Listen for notifications from some search UI to trigger search and suggest operations.
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.SearchRequested, object: nil, queue: nil) { notification in
            if let searchText = notification.searchText {
                searchNotificationHander(searchText)
            }
        }
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.SearchSuggestionsRequested, object: nil, queue: nil) { notification in
            if let searchText = notification.searchText {
                suggestNotificationHandler?(searchText)
            }
        }
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.SearchRequestedFromSuggestion, object: nil, queue: nil) { notification in
            if let suggestion = notification.suggestion {
                searchFromSuggestionNotificationHandler?(suggestion)
            }
        }
    }

    // MARK: Post Notifications shortcuts
    static func postSearchNotification(searchBar:UISearchBar) {
        // Notify that we'd like to do a search based off a SearchBar's text.
        if let searchText = searchBar.text {
            NotificationCenter.default.post(name: MapsAppNotifications.Names.SearchRequested, object: nil,
                                            userInfo: [SearchNotificationKeys.search: searchText])
        }
    }
    
    static func postSearchFromSuggestionNotification(suggestion:AGSSuggestResult) {
        // Notify that we'd like to do a search based off an AGSSuggestResult.
        NotificationCenter.default.post(name: MapsAppNotifications.Names.SearchRequestedFromSuggestion, object: nil,
                                        userInfo: [SearchNotificationKeys.suggestion: suggestion])
    }
    
    static func postSuggestNotification(searchBar:UISearchBar) {
        // Notify that we'd like to get search suggestions based off a SearchBar's text.
        if let suggestText = searchBar.text, suggestText.characters.count > 0 {
            NotificationCenter.default.post(name: MapsAppNotifications.Names.SearchSuggestionsRequested, object: nil,
                                            userInfo: [SearchNotificationKeys.search: suggestText])
        } else {
            MapsAppNotifications.postSearchCompletedNotification()
        }
    }
    
    static func postSearchCompletedNotification() {
        // Notify that we're no longer searching and it's time to hide any related UI (e.g. the suggestion panel)
        NotificationCenter.default.post(name: MapsAppNotifications.Names.SearchCompleted, object: nil)
    }
}

extension Notification {
    var searchText:String? {
        get {
            if [MapsAppNotifications.Names.SearchRequested, MapsAppNotifications.Names.SearchSuggestionsRequested].contains(self.name) {
                return self.userInfo?[SearchNotificationKeys.search] as? String
            }
            return nil
        }
    }
    
    var suggestion:AGSSuggestResult? {
        get {
            if self.name == MapsAppNotifications.Names.SearchRequestedFromSuggestion {
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
