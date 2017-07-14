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
    static let SearchCompleted = Notification.Name("MapsAppSearchCompletedNotification")
    static let SearchSuggestionsAvailable = Notification.Name("MapsAppSearchSuggestionsAvailableNotification")
}

extension MapsAppNotifications {
    // MARK: Post Notifications shortcuts
    static func postSearchSuggestionsAvailableNotification(suggestions:[AGSSuggestResult]) {
        // Notify that we'd like to get search suggestions based off a SearchBar's text.
        var userInfo:[AnyHashable:Any] = [:]
        
        if suggestions.count > 0 {
            userInfo[SearchNotificationKeys.suggestions] = suggestions
        }
        
        NotificationCenter.default.post(name: MapsAppNotifications.Names.SearchSuggestionsAvailable, object: nil, userInfo: userInfo)
    }
    
    static func postSearchCompletedNotification(result:AGSGeocodeResult? = nil) {
        // Notify that we're no longer searching and it's time to hide any related UI (e.g. the suggestion panel)
        var userInfo:[AnyHashable:Any] = [:]
        
        if let result = result {
            userInfo[SearchNotificationKeys.searchResult] = result
        }
        
        NotificationCenter.default.post(name: MapsAppNotifications.Names.SearchCompleted, object: nil, userInfo: userInfo)
    }
    
    static func observeSearchNotifications(searchResultHandler:((AGSGeocodeResult?)->Void)?, suggestionsAvailableHandler:(([AGSSuggestResult]?)->Void)?) {
        if let searchResultHandler = searchResultHandler {
            NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.SearchCompleted, object: nil, queue: OperationQueue.main) { notification in
                searchResultHandler(notification.searchResult)
            }
        }
        
        if let suggestionsAvailableHandler = suggestionsAvailableHandler {
            NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.SearchSuggestionsAvailable, object: nil, queue: OperationQueue.main) { notification in
                suggestionsAvailableHandler(notification.searchSuggestions)
            }
        }
    }
}

extension Notification {
    var searchResult:AGSGeocodeResult? {
        get {
            if self.name == MapsAppNotifications.Names.SearchCompleted {
                return self.userInfo?[SearchNotificationKeys.searchResult] as? AGSGeocodeResult
            }
            return nil
        }
    }

    var searchSuggestions:[AGSSuggestResult]? {
        get {
            if self.name == MapsAppNotifications.Names.SearchSuggestionsAvailable {
                return self.userInfo?[SearchNotificationKeys.suggestions] as? [AGSSuggestResult]
            }
            return nil
        }
    }
}

fileprivate struct SearchNotificationKeys {
    static let searchResult = "result"
    static let suggestions = "suggestions"
}
