# Release 1.0.4

* Certification for the 100.8.0 release of the ArcGIS Runtime SDK for iOS.

Note:
Starting from the 100.8 release, the ArcGIS Runtime SDK for iOS uses Apple's Metal framework to display maps and scenes. However, Xcode does not support Metal based rendering in iOS 12 simulators on macOS Catalina, or in any version of iOS simulator on macOS Mojave. If you are developing map or scene based apps in these environments, you will need test and debug them on a physical device instead of the simulator.

# Release 1.0.3

- Updates minimum deployment target to match that supported by ArcGIS iOS Runtime SDK.
- Turns off metal validation -> fixes iOS 12 device crash.
- New bundle ID.
- Remove Unit Test targets.

# Release 1.0.2

* Certification for the 100.7.0 release of the ArcGIS Runtime SDK for iOS.

# Release 1.0.1

* [Bug fix](https://github.com/Esri/maps-app-ios/issues/89) to dispatch UI updates to main thread.
* Ensures app builds with iOS 13.
* Adds [app documentation](/docs/index.md) from the ArcGIS for Developers site.
