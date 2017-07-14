//
//  SearchNotificationHelper.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

// MARK: External Notification API
extension MapsAppNotifications {
    // MARK: Register Listeners
    static func observeSearchNotifications(searchResultHandler:@escaping ((AGSGeocodeResult?)->Void), suggestionsAvailableHandler:(([AGSSuggestResult]?)->Void)?) {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.SearchCompleted, object: mapsApp, queue: OperationQueue.main) { notification in
            searchResultHandler(notification.searchResult)
        }
        
        if let suggestionsAvailableHandler = suggestionsAvailableHandler {
            NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.SearchSuggestionsAvailable, object: mapsApp, queue: OperationQueue.main) { notification in
                suggestionsAvailableHandler(notification.searchSuggestions)
            }
        }
    }
}



// MARK: Internals
extension MapsAppNotifications {
    static func postSearchSuggestionsAvailableNotification(suggestions:[AGSSuggestResult]) {
        // Notify that we'd like to get search suggestions based off a SearchBar's text.
        var userInfo:[AnyHashable:Any] = [:]
        
        if suggestions.count > 0 {
            userInfo[SearchNotificationKeys.suggestions] = suggestions
        }
        
        NotificationCenter.default.post(name: MapsAppNotifications.Names.SearchSuggestionsAvailable, object: mapsApp, userInfo: userInfo)
    }
    
    static func postSearchCompletedNotification(result:AGSGeocodeResult? = nil) {
        // Notify that we're no longer searching and it's time to hide any related UI (e.g. the suggestion panel)
        var userInfo:[AnyHashable:Any] = [:]
        
        if let result = result {
            userInfo[SearchNotificationKeys.searchResult] = result
        }
        
        NotificationCenter.default.post(name: MapsAppNotifications.Names.SearchCompleted, object: mapsApp, userInfo: userInfo)
    }
}

// MARK: Typed Notification Pattern
extension MapsAppNotifications.Names {
    static let SearchCompleted = Notification.Name("MapsAppSearchCompletedNotification")
    static let SearchSuggestionsAvailable = Notification.Name("MapsAppSearchSuggestionsAvailableNotification")
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

// MARK: Internal Constants
fileprivate struct SearchNotificationKeys {
    static let searchResult = "result"
    static let suggestions = "suggestions"
}
