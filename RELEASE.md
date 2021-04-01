# Release 1.0.8

-

# Release 1.0.7

- The 100.10 release of the ArcGIS Runtime for iOS is now distributed as a binary framework.  This necessitated the following changes in the Maps App Xcode project file:
    - The `ArcGIS.framework` framework has been replaced with `ArcGIS.xcframework`.
    - The Build Phase which ran the `strip-frameworks.sh` shell script is no longer necessary.
- Certification for the 100.10 release of the ArcGIS Runtime SDK for iOS.
- Increments app and testing deployment targets to iOS 13.0, drops support for iOS 12.0.

# Release 1.0.6

- Certification for the 100.9.0 release of the ArcGIS Runtime SDK for iOS.

# Release 1.0.5

- Adds support for all screen sizes per Apple's new App Store requirements detailed here: [Building Adaptive User Interfaces for iPhone and iPad](https://developer.apple.com/news/?id=01132020b).
- Adds doc table of contents to root README.md and docs/index.md
- Renames docs/index.md to [docs/README.md](/docs/README.md)

# Release 1.0.4

- Certification for the 100.8.0 release of the ArcGIS Runtime SDK for iOS.

# Release 1.0.3

- Updates minimum deployment target to match that supported by ArcGIS iOS Runtime SDK.
- Turns off metal validation -> fixes iOS 12 device crash.
- New bundle ID.
- Remove Unit Test targets.

# Release 1.0.2

- Certification for the 100.7.0 release of the ArcGIS Runtime SDK for iOS.

# Release 1.0.1

- [Bug fix](https://github.com/Esri/maps-app-ios/issues/89) to dispatch UI updates to main thread.
- Ensures app builds with iOS 13.
- Adds [app documentation](/docs/README.md) from the ArcGIS for Developers site.
