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
    static func observeSearchNotifications(searchResultHandler:@escaping ((AGSGeocodeResult?)->Void), suggestionsAvailableHandler:(([AGSSuggestResult]?)->Void)? = nil) {
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
