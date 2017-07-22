# Maps-App iOS

The Maps App is an example application to show some good practices when building applications around the ArcGIS Runtime SKD for iOS. It also includes a modular UI, components of which can be re-used in your own applications.

## Usage

The app operates in one of 3 "modes":

* Searching
* Display a Geocode Result
* Display a Directions Result

The main UI component is the Feedback View at the top of the Map View. It reflects the current mode and can be a SearchBar, a Geocode Result, or a Directions Result.

![Search Mode](/docs/images/app-modes.png)

 The controls at the bottom right are as follows:

 | Icon | Description |
 | ---- | ----------- |
 | ![GPS Tracking](/docs/images/control-gps.png) | Cycle through GPS recentering modes. |
 | ![Basemap Picker](/docs/images/control-basemaps.png) | Display a basemap picker. |
 | ![Account View](/docs/images/control-account.png) | Display the Account Items viewer. |

 In addition, a user can be logged in or logged out. When logged in the user can browse their account's Web Maps and can get directions (which consumes credits).

 Additionally, if the user's organization has custom basemaps configured, when logged in the user will be able to pick from those in the Basemap picker, but otherwise will see just the default ArcGIS Online basemaps.

## Architecture
The Maps App is built around 4 core components:

1. A singleton `AppContext` to manage the app's current state ([learn more](Maps%20App/App%20Context)).
2. A singleton `ArcGISServices` component to handle geocode and directions calls to the ArcGIS platform ([learn more](Maps%20App/ArcGIS%20Services)).
2. An interactive Map View and [controller](UI/Map%20View).
3. A decoupled, [modular UI](UI).

Any component of the app can directly read and write the `AppContext`. Changes to the `AppContext` raise Notifications using iOS's in-built `NSNotificationCenter` to which the Map View and the UI can react.

![App Architecture](/docs/images/app-architecture.png)

### UI
There is also a modular UI made up of the following components:

* Map View
* Feedback View
    * Suggestions View
    * Directions Maneuver View
* Account View & Web Maps Browser
* Basemaps Browser
* North Arrow

The Web Map Browser and Basemap Browser both make use of a Portal Item Browser control that can display an array of AGSPortalItems.

## App Lifecycle
When the app starts up, the MapsAppDelegate instance is created, which instatiates three singletons as instance variables:

* appContext
* arcGISServices
* preferences

iOS then calls the MapsAppDelegate's `application(_:didFinishLaunchingWithOptions:)` function where the app sets the ArcGIS Runtime License and sets up the initial AGSPortal object. This object will point to either ArcGIS Online or a custom on-premise ArcGIS Portal, depending on what URL is stored in the user preferences.

iOS will then begin setting up the UI. This is a Single View Application and the main storyboard defines the MapViewController and various UI components to go with it.

