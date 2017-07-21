# Maps App

The Maps App for iOS shows how a robust application can be built around the ArcGIS Platform using the Runtime SDK. It demonstrates best practices around some simple but key functionality of the ArcGIS Runtime, including:

* Search, including Geocoding and Reverse Geocoding.
* Turn-by-turn Routing and Directions.
* Opening ArcGIS Web Map content.
* Accessing and using Basemaps.
* Working with ArcGIS Online or an on-premise ArcGIS Portal.
* OAuth authentication.
* Defining a modular, decoupled UI that operates alongside a map view.


## Architecture
The Maps App is built around 3 core components:

1. A central AppContext to manage the app's current state.
2. An interactive Map View.
3. A decoupled, modular UI.

All components of the app can directly read and write the AppContext, and operations on the AppContext raise Notifications using iOS's in-built NSNotificationCenter to which other parts of the app (e.g. the Map or the UI) can respond.

## Implementation
When an iOS application starts up, iOS instatiates a singleton obect implementing the `UIApplicationDelegate` protocol. In this case, this is an instance of the `MapsAppDelegate` class. Read more about the `MapsAppDelegate` class [here](/maps-app-ios/Maps%20App/Maps%20App%20Delegate).

That singleton instance maintains a few key components which are referenced through global shortcuts.

The most important of these are the `AppContext` instance and the `ArcGISServices` instance. Changes to the AppContext or functions called on either of these objects may cause Notifications to be raised which the rest of the application can react to. To find out more, see here.

### AppContext
The AppContext is the core of the app. Any component of the app can interact with the AppContext to set or read changes in the app's state, such as whether the user is logged in or not, or what the current portal is.

### ArcGISServices
The ArcGIS Services object can be used to make Geocode or Routing requests. When these requests are completed, Notifications are raised which can be reacted to by the rest of the app (e.g. the UI or the Map View).

## Configuration
Configuration of the app is split in two between [static settings](AppSettings.swift) and [User Preferences](AppPreferences.swift).

### Preferences
Preferences such as the current portal and the current map extent are stored by the AppPreferences instance using iOS's UserDefaults.

### Settings
The `AppSettings` class contains static variables defined at build-time that can be read for configuring the application at runtime, such as the `AppID` and the OAuth URL used to complete the OAuth authentication process.
