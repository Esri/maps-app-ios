## Implementation
When an iOS application starts up, a singleton instance of an obect implementing the `UIApplicationDelegate` protocol is created (learn more [here](https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/TheAppLifeCycle/TheAppLifeCycle.html#//apple_ref/doc/uid/TP40007072-CH2-SW2)). In the Maps App's case, this is an instance of the `MapsAppDelegate` class. Read more about the `MapsAppDelegate` class [here](/maps-app-ios/Maps%20App/Maps%20App%20Delegate).

That singleton instance maintains a few key components which are referenced through global shortcuts.

The most important of these are `AppContext` and `ArcGISServices` instances. Changes to the AppContext or functions called on either of these objects cause Notifications to be raised which the rest of the application can react to. To find out more, see here.

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
