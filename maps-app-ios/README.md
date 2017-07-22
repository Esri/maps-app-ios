# Maps-App iOS

The Maps App for iOS shows how a robust application can be built around the ArcGIS Platform using the [ArcGIS Runtime SDK for iOS](https://developers.arcgis.com/ios/). It demonstrates best practices around some simple but key functionality of the ArcGIS Runtime. You can use the Maps App as is, or extend it to meet your specific needs.

## Features
* Place Search.
* Geocoding.
* Reverse Geocoding.
* Turn-by-turn Directions.
* Dynamically switching basemaps.
* Opening Web Maps.
* Working with ArcGIS Online or an on-premise ArcGIS Portal.
* OAuth authentication.

## Best Practices
The project also demonstrates some patterns for building real-world apps around the ArcGIS Runtime SDK.

* Defining a modular, decoupled UI that operates alongside a map view.
* Internal application communication patterns.
* Asynchronous service and UI coding patterns.

## Development Instructions
The Maps App is a GitHub repository that can be cloned and opened in Apple's Xcode. You will need Xcode and the ArcGIS Runtime SDK (v100.1 or later) installed locally. Then open the maps-app-ios.xcodeproj file in Xcode.

The app can be run as is, but for turn-by-turn directions and to open your own Portal's Web Maps, you will need to do some one-off configuration, as follows:

1. Register an ArcGIS Portal Application.
2. Configure the Maps App project to reference that application.
3. Optionally license the app to remove the Developer Mode watermark.

### 1. Register an Application 
For OAuth configuration, you should create a new Application in your ArcGIS Portal to obtain a `Client ID` and set up a `Redirect URL`. By configuring these items, you tell the Runtime how to show your users that the application was built by you and can be trusted, and you tell the OAuth process how it can return to your app once authentication is complete.

1. Log in to [https://developers.arcgis.com](https://developers.arcgis.com) with either your ArcGIS Organizational Account or an ArcGIS Developer Account.
2. Register a new Application. ![Register new application](/docs/images/create-application.png)
3. In the Authentication tab, note the Client ID and add a Redirect URL, e.g. `my-maps-app://auth`. We will use this URL in the **Configuring the project** section below. ![Configure new application](/docs/images/configure-application.png)

### 2. Configuring the project
Open the project in Xcode and browse to the `maps-app-ios` target's `Info` panel and expand the `AGSConfiguration` dictionary (see steps 1...4 in the screenshot below).

1. Set the `ClientID` value to the application's Client ID noted above.
2. Set the `AppURLScheme` value to match the Redirect URL scheme (the part *before* the `://`, e.g. `my-maps-app`) configured in "Register an Application" above.
3. Expand the **URL Types** section and modify the existing entry. ![Configure the App URL Scheme](/docs/images/configure-xcode-target.png)
    1. The **Identifier** doesn't matter, but should be unique (e.g. `com.my-org.awesome-maps-app`).
    2. The **URL Scheme** should match the Redirect URL scheme (the part *before* the `://`, e.g. `my-maps-app`) configured in "Register an Application" above.

### 3. License the app (Optional)
To remove the _Licensed for Developer Use Only_ watermark on the map view, set the `LicenseKey` in the `AGSConfiguration` dictionary. Retrieve this value by clicking the `Show my ArcGIS Runtime Lite license key` at the top-right of the [Licensing Your ArcGIS Runtime App](https://developers.arcgis.com/arcgis-runtime/licensing/) page (you must be logged in).

## Architecture
The Maps App is built around 4 core components:

1. A singleton `AppContext` to manage the app's current state.
2. A singleton `ArcGISServices` component to handle geocode and directions calls to the ArcGIS platform.
2. An interactive Map View and [controller](UI/Map%20View).
3. A decoupled, [modular UI](UI).

Any component of the app can directly read and write the `AppContext`. Changes to the `AppContext` raise Notifications using iOS's in-built `NSNotificationCenter` to which the Map View and the UI can react.

![App Architecture](/docs/images/app-architecture.png)
