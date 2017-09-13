# Maps App Notifications
Notifications are used throughout the Maps App to inform the UI that state has changed or ArcGIS Service tasks such as Routing or Geocoding have completed.

Notifications include:

| Source | Notifications |
| ------ | ------------- |
| `AppContext` | Login, Logout, New Basemap Selected, New Web Map Selected |
| `ArcGISServices` | Search Suggestions Available, Search/Geocode completed, Route calculated |
| `MapViewController` | Mode Changed |

## Implementation
Components register interest in a notification by calling an **observe** function and providing a callback block. That block will be called when the notification is received, and is passed strongly typed parameters from the notification.

These static **observe** functions are named `MapsAppNotifications.observeXYZNotification()` (where `XYZ` is the notification). Components call them to register their interest in that notification without needing to know the details of how that notification is implemented.

Notification types are added using Swift Extensions (in this case the Login/Logout notifications):

``` Swift
// From LoginNotifications.swift

extension MapsAppNotifications {
    static func observeLoginStateNotifications(loginHandler:((AGSPortalUser)->Void)?, 
                                               logoutHandler:(()->Void)?) {
        // ...
    }
}
```

To be notified of login/logout events, simply call `MapsAppNotifications.observeLoginStateNotifications()` passing blocks that handle the login and logout events.

This pattern turns Apple's stringly-typed NSNotification implementation into something strongly-typed. This has the following benefits:

* Auto-complete makes it easier to determine available notifications while coding.
* Interested parties' callback blocks are simpler:
    * The Notification's `userInfo` dictionary has already been parsed into strongly typed parameters.
    * No boilerplate is required.
    * The observer doesn't need to worry about the source of the notification.
    * Notification handlers are easier to write and understand --> Fewer bugs.

## Example usage: Handling Search Results
The MapViewController registers its interest in search results with this code (found [here](/maps-app-ios/UI/Map%20View/MapViewController+Search/MapViewController+SearchSetup.swift)):
``` Swift
// From MapViewController

MapsAppNotifications.observeSearchNotifications(searchResultHandler: { result in
    if let result = result {
        self.mode = .geocodeResult(result)
    }
})
```

When a search completes, the `ArcGISService` singleton posts the appropriate notification which triggers the above block.

The definition of `observerSearchNotifications()` declares `result` in the above block as an `AGSGeocodeResult`:

``` Swift
static func observeSearchNotifications(searchResultHandler:@escaping ((AGSGeocodeResult?)->Void),
                                       suggestionsAvailableHandler:(([AGSSuggestResult]?)->Void)? = nil)
```

So, when `self.mode` is updated in the block above, it in turn posts a `ModeChange` notification (by convention each `observe` function typically has a corresponding `post` function).

``` Swift
// From MapViewController

var mode:MapViewMode = .none {
    didSet {
        updateMapViewForMode()

        // Announce that the mode has changed (the Feedback Panel UI listens to this)
        MapsAppNotifications.postModeChangeNotification(oldMode: oldValue, newMode: mode)
    }
}
```

When first loaded, `FeedbackViewController` registers for `ModeChange` notifications with the following, which allows it to respond to the `ModeChange` notification posted by the `MapViewController` above:

``` Swift
// From FeedbackViewController

MapsAppNotifications.observeModeChangeNotification { oldValue, newValue in
    // Set the UI to Search, Show Geocode, or Show Directions…
    self.setUIForMode(mode: newValue, previousMode: oldValue)
}
```

The overall effect is that when the `ArcGISService` singleton completes a search, `MapViewController.mode` is updated, which in turn updates the `FeedbackViewController`, even though no one object knows about the others.

At no point did the code need to know what the notification's name was nor how to unpack the `userInfo` dictionary and cast its content to `AGSGeocodeResult` or `MapViewMode` as this was all implemented in the `observe` and `post` functions, clearing up the code to focus solely on application logic.