# AppContext

The `AppContext` is the central component of the app. It is a singleton instance created by the `MapsAppDelegate` on applications start.

`AppContext` contains multiple instance variables that track the state of the app, such the current Portal, and whether the user is currently logged in. See [AppContext.swift](AppContext.swift).

When the portal is updated or the user logs in or logs out, the `AppContext` will query the portal to update the [geocoding and routing service URLs](AppContext+PortalServices.swift) and the [list of basemaps](AppContext+PortalServices.swift#L42).

It also provides methods and logic to log in and log out of the current portal. These methods can be called from the app's UI. They use the ArcGIS Runtime SDK's `AGSPortal` and `AGSCredentialCache` along with `AGSOAuthConfiguration` to log in to the portal.

## Log in to an AGSPortal
To log in, the `AppContext` creates a new `AGSPortal` instance passing in `loginRequired: true`:

``` Swift
// From AppContext+Login.swift

func logIn(portalURL:URL?) {
    // Explicitly log in
    if let url = portalURL {
        currentPortal = AGSPortal(url: url, loginRequired: true)
    } else {
        // No URL was provided, so we'll just use ArcGIS Online.
        currentPortal = AGSPortal.arcGISOnline(withLoginRequired: true)
    }
}
```

The `currentPortal` instance variable's `didSet` block ensures that the `currentPortal` is set up correctly for OAuth:

``` Swift
var currentPortal:AGSPortal? {
    didSet {
        // Forget any authentication rules for the previous portal.
        AGSAuthenticationManager.shared().oAuthConfigurations.removeAllObjects()
        
        if let portal = currentPortal {
            setupAndLoadPortal(portal: portal)
        }
    }
}

func setupAndLoadPortal(portal:AGSPortal) {
    // Ensure the Runtime knows how to authenticate against this portal should the need arise.
    let oauthConfig = AGSOAuthConfiguration(portalURL: portal.url, clientID: AppSettings.clientID,
                                            redirectURL: "\(AppSettings.appSchema)://\(AppSettings.authURLPath)")
    AGSAuthenticationManager.shared().oAuthConfigurations.add(oauthConfig)
    
    // Now load the portal so we can get some portal-specific information from it.
    portal.load() { error in
        guard error == nil else {
            print("Error loading the portal: \(error!.localizedDescription)")
            return
        }
        
        // Read the locator and route task from the portal, and load the basemaps group.
        self.updateServices(forPortal: portal)
        
        // Record whether we're logged in to this new portal.
        if let user = portal.user {
            self.loginStatus = .loggedIn(user: user)
        } else {
            self.loginStatus = .loggedOut
        }
    }
}
```

The `setupAndLoadPortal()` function ensures the portal is configured for OAuth. Since it was created with `loginRequired: true`, the OAuth workflow will be triggered when `portal.load()` is called.

Once the portal has loaded, its `user` property will reflect the current user. If no user logged in, this will be `nil`, otherwise it will point to a valid `AGSPortalUser` instance. `setupAndLoadPortal()` will set the `AppContext.loginStatus` instance variable, which will raise a [AppLogin or AppLogout Notification](/maps-app-ios/Maps%20App/App%20Notifications) which the app's UI can react to.

``` Swift
var loginStatus:LoginStatus = .loggedOut {
    didSet {
        switch loginStatus {
        case .loggedIn(let user):
            print("Logged in as user \(user)")
            MapsAppNotifications.postLoginNotification(user: user)
        case .loggedOut:
            print("Logged out")
            MapsAppNotifications.postLogoutNotification()
        }
    }
}
```

## Log out of an AGSPortal
To log out, the `AppContext` creates a new `AGSPortal` instance passing in `logingRequired: false`:

``` Swift
func logOut() {
    // Ensure we forget everything we know about logging in to this portal.
    AGSAuthenticationManager.shared().credentialCache.removeAllCredentials()
    
    // Explicitly log out
    if let portalURL = mapsAppPrefs.portalURL {
        currentPortal = AGSPortal(url: portalURL, loginRequired: false)
    } else {
        // No URL was provided, so we'll just use ArcGIS Online.
        currentPortal = AGSPortal.arcGISOnline(withLoginRequired: false)
    }
}
```

The `AGSCredentialCache` maintains credentials for the ArcGIS Runtime, synced to the iOS Keychain (this is not the default behavior, but Maps App opts in to this [on app launch](AppContext+Portal.swift#L20) in `setInitialPortal()`). To ensure no credentials are left behind after a logout (which could allow authenticated access) call `removeAllCredentials()` as above.

This time when `setupAndLoadPortal()` is called, the `portal.user` property will be `nil`.

## Read a portal's Geocoder and Route Service URLs
An `AGSPortal` maintains information about helper services. ArcGIS Online provides powerful default global services, but many Portal Administrators override or augment these with their own (e.g. a municipality's geocoder or a utility company's routing service).

The Maps App reads these services from the `AGSPortal` to reflect the services configured by the Portal Administrator (see [AppContext+PortalServices.swift](AppContext+PortalServices.swift), and instantiates both an `AGSLocatorTask` and an `AGSRouteTask` accordingly:

``` Swift
if let svcs = portal.portalInfo?.helperServices {
    if let geocoderURL = svcs.geocodeServiceURLs?.first, geocoderURL != arcGISServices.locator.url {
        arcGISServices.locator = AGSLocatorTask(url: geocoderURL)
    }
    
    if let routeTaskURL = svcs.routeServiceURL, routeTaskURL != arcGISServices.routeTask.url {
        arcGISServices.routeTask = AGSRouteTask(url: routeTaskURL)
    }
}
```

Note that there could be many geocoders defined for a Portal, but the Maps App current only uses the first one found.
