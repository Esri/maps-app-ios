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

class AppContext {
    
    // MARK: Portal Information
    /**
     The app's current portal.
     
     The portal drives whether the user is signed in or not, the URLs for the Route and Geocoding services, and also which basemaps
     are available to choose from.
     
     When set, the portal is configured for OAuth authentication so that if login is required, the Runtime SDK and iOS can work together
     to authenticate the current user.
     */
    var currentPortal:AGSPortal? {
        didSet {
            // Forget any authentication rules for the previous portal.
            AGSAuthenticationManager.shared().oAuthConfigurations.removeAllObjects()
            
            if let portal = currentPortal {
                setupAndLoadPortal(portal: portal)
            }
        }
    }

    /**
     Available basemaps for the app to choose from.
     */
    var basemaps:[AGSPortalItem] = []

    /**
     The current selected basemap.
     */
    var currentBasemap:AGSPortalItem? {
        didSet {
            if let newBasemap = currentBasemap {
                MapsAppNotifications.postCurrentBasemapChangedNotification(basemap: newBasemap)
            }
        }
    }
    
    /**
     A handle onto the Root Folder for the current user.
     */
    var rootFolder:PortalUserFolder? {
        didSet {
            currentFolder = rootFolder
        }
    }
    
    /**
     A handle onto the current folder being used in the Accounts panel's Portal Items browser.
     */
    var currentFolder:PortalUserFolder? {
        didSet {
            MapsAppNotifications.postCurrentFolderChangeNotification()
        }
    }
    
    /**
     The current portal item (if any) displayed in the map.
     */
    var currentItem:AGSPortalItem? {
        didSet {
            MapsAppNotifications.postCurrentItemChangeNotification()
        }
    }

    /**
     Returns whether we are currently signed in to the current portal.
     */
    var isSignedIn:Bool {
        return self.currentUser != nil
    }
    
    /**
     Return the current signed-in user, if any.
     */
    var currentUser:AGSPortalUser? {
        didSet {
            if let user = currentUser {
                print("Signed in as user \(user)")
                self.rootFolder = PortalUserFolder.rootFolder(forUser: user)
                MapsAppNotifications.postSignedInNotification(user: user)
            } else {
                if let oldUser = oldValue {
                    print("\(oldUser) signed out")
                }
                self.rootFolder = nil
                MapsAppNotifications.postSignedOutNotification()
            }
        }
    }

    // MARK: MapView UI
    /**
     The current AGSMapView for the app.
     
     At present there will only ever be one of these since this is a single view app with only
     one map view.
     */
    var currentMapView:AGSMapView?
    
    var routeResult:AGSRouteResult?
    
    /**
     A flag determining whether it is OK to show search suggestions.
     
     This should be set to true while the user is typing into a searchBar, and is otherwise set to false.
     */
    var validToShowSuggestions:Bool = false {
        didSet {
            if !validToShowSuggestions {
                MapsAppNotifications.postSearchSuggestionsAvailableNotification(suggestions: [])
            }
        }
    }

}
