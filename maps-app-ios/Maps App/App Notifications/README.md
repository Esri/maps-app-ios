# Maps App Notifications
Notifications are used throughout the Maps App to inform the UI that state has changed or ArcGIS Service tasks such as Routing or Geocoding have completed.

Notifications include:

| Source | Notifications |
| ------ | ------------- |
| `AppContext` | Login, Logout, New Basemap Selected, New Web Map Selected |
| `ArcGISServices` | Search Suggestions Available, Search/Geocode completed, Route calculated |
| `MapViewController` | Mode Changed |

## Implementation
Interested components register that interest by calling a function and providing a callback block. That block will be called when the notification is received, and is passed strongly typed parameters from the notification.

For example, the MapViewController registers its interest in search results with this code (found [here](/maps-app-ios/UI/Map%20View/MapViewController+Search/MapViewController+SearchSetup.swift)):
``` Swift
// From MapViewController

MapsAppNotifications.observeSearchNotifications(searchResultHandler: { result in
    if let result = result {
        self.mode = .geocodeResult(result)
    }
})
```

From the definition of `observerSearchNotifications()`, `result` will be known to be an `AGSGeocodeResult`:

``` Swift
static func observeSearchNotifications(searchResultHandler:@escaping ((AGSGeocodeResult?)->Void),
                                       suggestionsAvailableHandler:(([AGSSuggestResult]?)->Void)? = nil) {
```

In turn, when the MapViewController's `mode` property is updated above, it in turn posts a `Mode Change` notification, to which the UI listens and updates itself appropriately.

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

Continuing the above example, the `FeedbackViewController` uses the following code to be notified whenever the mode has changed:

``` Swift
MapsAppNotifications.observeModeChangeNotification { oldValue, newValue in
    self.setUIForMode(mode: newValue, previousMode: oldValue)
}
```

Each Notification will have an accompanying `observerXYZNotification()` function so that components can register their interest in that notification without needing to know the details about how that notification is implemented.

This pattern turns Apple's stringly-typed NSNotification implementation into something strongly-typed. This has the following benefits:

* Auto-complete makes it easier to determine available notifications while coding.
* Interested parties' callback blocks are simpler:
    * The Notification's `userInfo` dictionary has already been parsed into stronly typed parameters.
    * No boilerplate is required.
    * The observer doesn't need to worry about the source of the notification.
    * The callback blocks are easier to write and understand.
    * Fewer bugs in the callback blocks.

1. The MapsAppNotifications struct.
1. The type-safe patterns:
    1. The MapsAppNotifications.Names struct.
    1. `post` functions.
    1. Notification class extensions for `get` properties.
