# Maps App iOS

The Maps App is an example application to show some good practices when building applications around the ArcGIS Runtime SKD for iOS. It also includes a modular UI, components of which can be re-used in your own applications.

## Usage

The app operates in one of 3 "modes":

* Searching
* Display a Geocode Result
* Display a Route Result

The app user can be logged in or logged out from ArcGIS Online or an ArcGIS Portal. The user must log in to browse their account's Web Maps and get route directions (which consumes credits).

Additionally, if the user's organization has custom basemaps configured, when logged in the user will be able to pick from those in the Basemap picker, but otherwise will see just the default ArcGIS Online basemaps.

### User Interface
The main UI component is the Feedback View at the top of the Map View. It reflects the current mode and can be a SearchBar, a Geocode Result, or a Directions Result.

![Search Mode](/docs/images/app-modes.png)

The controls at the bottom right are as follows:

| Icon | Description |
| ---- | ----------- |
| ![GPS Tracking](/docs/images/control-gps.png) | Cycle through GPS recentering modes. |
| ![Basemap Picker](/docs/images/control-basemaps.png) | Display a basemap picker. |
| ![Account View](/docs/images/control-account.png) | Display the Account Items viewer. |

The app maintains a history of Search/Geocode/Reverse Geocode/Directions results and displays a `Previous` and `Next` button to browse through them if appropriate. You can also shake the device to initiate the iOS undo/redo behavior.

| Icon | Description |
| ---- | ----------- |
| ![Previous Result](/docs/images/control-prev-result.png) | View the previous result. |
| ![Next Result](/docs/images/control-next-result.png) | View the next result. |

## Architecture
The Maps App is built around 4 core components:

1. A singleton `AppContext` to manage the app's current state ([learn more](Maps%20App/App%20Context)).
2. A singleton `ArcGISServices` component to handle geocode and directions calls to the ArcGIS platform ([learn more](Maps%20App/ArcGIS%20Services)).
2. An interactive Map View and [controller](UI/Map%20View).
3. A decoupled, [modular UI](UI).

Components of the app read from and write to the `AppContext`. Changes to the `AppContext` raise Notifications using iOS's in-built `NSNotificationCenter` to which the UI can react.

![App Architecture](/docs/images/app-architecture.png)

## App Lifecycle
When the app starts up, the `MapsAppDelegate` instance is created, which instantiates the `AppContext` and `ArcGISServices` singletons.

iOS then calls the MapsAppDelegate's `application(_:didFinishLaunchingWithOptions:)` function where the app sets the ArcGIS Runtime License and sets up the initial AGSPortal object. This object will point to either ArcGIS Online or a custom on-premise ArcGIS Portal, depending on any URL stored in the user preferences.

iOS will then begin setting up the UI. The Maps App is a Single View Application and the main storyboard defines the `MapViewController` and various UI components to go with it.

When the `MapViewController` and UI are initialized, they read the current `AppContext` to initialize their appearance. They then register themselves as observers on specific custom Notifications that indicate changes to the `AppContext` so they can later update their appearance as appropriate whenever the `AppContext` is udpated.
