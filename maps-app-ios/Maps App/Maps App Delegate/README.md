# MapsAppDelegate

The MapsAppDelegate singleton instance is created by iOS when the application starts.

This class is responsible for handling events to do with application startup, shutdown, switching between background and foreground state etc.. Of particular importance to the ArcGIS Runtime are two delegate methods:

| Function | Notes |
| -------- | ----- |
| `application(_:didFinishLaunchingWithOptions:)` | Called when the application first starts. This is a good place to configure the ArcGIS Runtime SDK license. See [MapsAppDelegate+AppStartup.swift](MapsAppDelegate+AppStartup.swift) |
| `application(_:open:options:)` | Called when a custom URL scheme that is registered to this app is opened in iOS. In this case this is used by OAuth to call back to the application once the user has logged in using the OAuth login workflow. See [MapsAppDelegate+OAuthLogin.swift](MapsAppDelegate+OAuthLogin.swift) |

The MapsAppDelegate instance also has three key instance variables on it, defined in [MapsAppDelegate.swift](MapsAppDelegate.swift). These three key variables can be referenced through global variables defined in [MapsAppGlobals.swift](../MapsAppGlobals.swift):

| Global Variable | Notes |
| ------ | ----- |
| `mapsAppContext` | This singleton instance is the core of the app. App state is stored here, core functionality is avialable here, and any component of the app can reference the context. Changes to the context result in Notifications that the rest of the app can listen to and react to appropriately. For example, when the user logs out, a notification is sent from the AppContext so that the UI and Map Views can update themselves appropriately. |
| `arcGISServices` | This singleton handles performing ArcGIS Service operations, such as Geocoding and Routing. |
| `mapsAppPrefs` | This singleton is responsible for reading and writing user preferences, such as initial extent and current portal. |
