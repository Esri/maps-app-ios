Maps-App
=======================
## Description
Get your organization's authoritative map data into the hands of your workers with this ArcGIS Runtime iOS app. The application you build can include a custom web map from your [ArcGIS Online organization](https://doc.arcgis.com/en/arcgis-online/reference/what-is-agol.htm). For example, a [web map](http://doc.arcgis.com/en/living-atlas/item/?itemId=26888b0c21a44eb1ba2f26d1eb7981fe) from the Living Atlas can be used as a starting place for your app. The maps-app also includes examples of place search and routing capabilities using either ArcGIS Online's powerful services or your own services. It also leverages your organizations configured basemaps to allow users to switch between the basemap that make sense for them.

This example application is open source so grab the code at [GitHub](https://github.com/Esri/maps-app-ios) and either configure the app for your organization, or just learn how to integrate similar capabilities into your own app!

## Using Web Maps
You can author your own web maps from ArcGIS Online or ArcGIS Pro and share them in your app via your ArcGIS Online organization, this is the central power of the Web GIS model built into ArcGIS. Building an app which uses a web map allows the cartography and map configuration to be completed in ArcGIS Online rather than in code. This then allows the map to change over time, without any code changes or app updates. Learn more about the benefits of developing with web maps [here](https://developers.arcgis.com/web-map-specification/). Also, learn about authoring web maps in [ArcGIS Online](http://doc.arcgis.com/en/arcgis-online/create-maps/make-your-first-map.htm) and [ArcGIS Pro](http://pro.arcgis.com/en/pro-app/help/mapping/map-authoring/author-a-basemap.htm).

Loading web maps in code is really easy, the maps app loads a web map from a portal (which may require the user to login, see the identity section below) with the following code:

``` Swift
let portal = AGSPortal(url: URL(string: "https://<your portal url>")!, loginRequired: false)
let webMap = AGSPortalItem(portal: portal, itemID: "<your map id>")
mapView.map = AGSMap(item: webMap)
```
## Accessing Your Organization's Basemaps
As an administrator of an ArcGIS Online organization or Portal you can configure the basemaps that your users can switch between via a [group](http://doc.arcgis.com/en/arcgis-online/share-maps/share-items.htm). Applications can leverage this configuration using the [Portal API](https://developers.arcgis.com/android/beta/guide/access-the-arcgis-platform.htm#ESRI_SECTION2_B8EDBBD3D4F1499C80AF43CFA73B8292). The Maps App does this by an async call to find the group containing web maps in the basemap gallery. With the returned group id, the collection of basemaps is retrieved from the portal.

``` Swift
if let basemapGroupQuery = portal.portalInfo?.basemapGalleryGroupQuery {
    let params = AGSPortalQueryParameters(query: basemapGroupQuery)
    portal.findGroups(with: params, completion: { groups, error in
        guard error == nil else {
            print("Unable to get Basemaps Group! \(error!.localizedDescription)")
            return
        }
        
        guard let basemapGroup = groups?.results?.first as? AGSPortalGroup, let groupID = basemapGroup.groupID else {
            print("No error, but also no Basemap Group query results!")
            return
        }
        
        let groupParams = AGSPortalQueryParameters(forItemsInGroup: groupID)
        groupParams.limit = 50
        portal.findItems(with: groupParams, completion: { groupQueryResults, error in
            guard error == nil else {
                print("Error loading items for basemap group: \(error!.localizedDescription)")
                return
            }
            
            guard let basemapItems = groupQueryResults?.results as? [AGSPortalItem] else {
                print("Basemap results were not a set of AGSPortalItems")
                return
            }

            // Display the basemaps in a basemaps picker...
        })
    })
}
```

## Identity
The Maps App leverages the ArcGIS [identity](https://developers.arcgis.com/authentication/) model to provide access to resources via the the [named user](https://developers.arcgis.com/authentication/#named-user-login) login pattern. During the routing workflow, the app prompts you for your organization’s ArcGIS Online credentials used to obtain a token later consumed by the Portal and routing service. The ArcGIS Runtime SDKs provide a simple to use API for dealing with ArcGIS logins.

The process of accessing token secured services with a challenge handler is illustrated in the following diagram.

![](/docs/images/identity.png)

1. A request is made to a secured resource.
2. The portal responds with an unauthorized access error.
3. A challenge handler associated with the identity manager is asked to provide a credential for the portal.
4. A UI displays and the user is prompted to enter a user name and password.
5. If the user is successfully authenticated, a credential (token) is incuded in requests to the secured service.
6. The identity manager stores the credential for this portal and all requests for secured content includes the token in the request.

The `AGSOAuthConfiguration` class takes care of steps 1-6 in the diagram above. For an application to use this pattern, follow these [guides](https://developers.arcgis.com/authentication/signing-in-arcgis-online-users/) to register your app.
``` Swift
let oauthConfig = AGSOAuthConfiguration(portalURL: portal.url, clientID: clientId, redirectURL: oAuthRedirectURL)
AGSAuthenticationManager.shared().oAuthConfigurations.add(oauthConfig)
```

Any time a secured service issues an authentication challenge, the `AGSOAuthConfiguration` and the app's `UIApplicationDelegate` work together to broker the authentication transaction. The `oAuthRedirectURL` above tells iOS how to call back to the Maps App to confirm authentication with the Runtime SDK.

iOS knows to call the `UIApplicationDelegate` with this URL, and we pass that directly to an ArcGIS Runtime SDK helper function to retrieve a token:

``` Swift
// UIApplicationDelegate function called when "maps-app-ios://auth" is opened.
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    // Pass the OAuth callback through to the ArcGIS Runtime helper function
    AGSApplicationDelegate.shared().application(app, open: url, options: options)

    // Let iOS know we handled the URL OK
    return true
}
``` 

To tell iOS to call back like this, the Maps App configures a `URL Type` in the `Info.plist` file.

![OAuth URL Type](/docs/images/configure-url-type.png)

Note the value for URL Schemes. Combined with the text `auth` to make `maps-app-ios://auth`, this is the [redirect URI](https://developers.arcgis.com/authentication/browser-based-user-logins/#configuring-a-redirect-uri) that you configured when you registered your app [here](https://developers.arcgis.com/). For more details on the user authorization flow, see the [Authorize REST API](http://resources.arcgis.com/en/help/arcgis-rest-api/#/Authorize/02r300000214000000/).

For more details on configuring the Maps App for OAuth, see [the main README.md](/README.md#2-configuring-the-project)

## Place Search & Geocoding
[Geocoding](https://developers.arcgis.com/ios/latest/swift/guide/search-for-places-geocoding-.htm) lets you transform an address or a place name to a specific geographic location. The reverse lets you use a geographic location to find a description of the location, like a postal address or place name. In the Maps App, we use a [AGSLocatorTask](https://developers.arcgis.com/ios/latest/swift/guide/search-for-places-geocoding-.htm#ESRI_SECTION1_62AE6A47EB4B403ABBC72337A1255F8A) to perform geocoding and reverse geocoding functions provided by [Esri's World Geocoding Service](https://developers.arcgis.com/features/geocoding/). The `AGSLocatorTask` has various asynchronous methods that we use to provide address suggestions when searching for places or geocoding locations.

You can also provision your own [custom geocode service](https://doc.arcgis.com/en/arcgis-online/administer/configure-services.htm#ESRI_SECTION1_0A9A071A7AB748028C8213D1D863FA18) to support your organization. Maps App reads the first locator from the list of locators provisioned for an ArcGIS Online organization or Portal.

``` Swift
if let geocoderURL = portal.portalInfo?.helperServices?.geocodeServiceURLs?.first {
    locator = AGSLocatorTask(url: geocoderURL)
}
```

Before using the `AGSLocatorTask` for geocode or searching for places, it must be LOADED. The loadable pattern is described [here](https://developers.arcgis.com/ios/latest/swift/guide/loadable-pattern.htm).

The ArcGIS Runtime SDK for iOS is implemented so that any action on a loadable task is queued internally until the task is loaded. This means that you can safely write code like the following and allow the ArcGIS Runtime to handle the load behind the scenes before any geocode request is sent:

``` Swift
func search(searchText:String) {
    locator.geocode(withSearchText: searchText, parameters: params) { results, error in
        guard error == nil else {
            // This could be a load error OR a search error...
            print("Error performing search! \(error!.localizedDescription)")
            return
        }
        
        if let result = results?.first {
            // Do something with the result...
        } else {
            print("\"\(searchText)\" returned no results.")
        }
    }
}
```

 If the `AGSLocatorTask` above is already loaded, the ArcGIS Runtime SDK doesn't try to load again but moves straight on to the actual geocode.

## Place Suggestions
Typing the first few letters of a place into the Map App search box (e.g. “Central Park”) shows a number of suggestions near the device’s location.

![](/docs/images/app-suggestions.png)

This is a simple call on the `AGSLocatorTask`:

``` Swift
func getSuggestions(forSearchText searchText:String) {
    locator.suggest(withSearchText: searchText) { suggestions, error in
        guard error == nil else {
            // This could be a load error OR a suggestions error...
            print("Error getting suggestions for \"\(searchText)\": \(error!.localizedDescription)")
            return
        }
        
        // ...Display the suggestions for the user to pick one...
    }
}
```

If there is a property you need to read before calling an async action on the loadable task, then you must explicitly load the task (in the following code, the above code is updated slightly to determine whether the locator supports interactive suggestions):

``` Swift
func getSuggestions(forSearchText searchText:String) {
    locator.load { error in
        guard error == nil else {
            // This is a load error...
            print("Error loading locator: \(error!.localizedDescription)")
            return
        }
        
        guard self.locator.locatorInfo?.supportsSuggestions == true else {
            return
        }
        
        self.locator.suggest(withSearchText: searchText) { suggestions, error in
            // This is a suggestions error...
            // Any load error would have been caught above...
            guard error == nil else {
                print("Error getting suggestions for \"\(searchText)\": \(error!.localizedDescription)")
                return
            }
            
            // ...Display the suggestions for the user to pick one...
        }
    }
}
```

Note how the above two patterns work to coalesce loading and asynchronous actions. Understanding this can guide how you might present errors to the user.

## Searching from a Suggestion
Once a suggestion in the list has been selected by the user, the suggested address is geocoded using the geocode function of the `AGSLocatorTask`. Along with the address, specific [geocoding parameters](https://developers.arcgis.com/ios/latest/swift/guide/search-for-places-geocoding-.htm#ESRI_SECTION1_62AE6A47EB4B403ABBC72337A1255F8A) can be set to tune the results. For example, in the maps app, we set the [preferred location](https://developers.arcgis.com/ios/latest/api-reference/interface_a_g_s_geocode_parameters.html#a8d2dbede94ed26ecde13f9d766d767e2) to prioritize results closer to the center of the map.
``` Swift
func search(suggestion:AGSSuggestResult) {
    let params = AGSGeocodeParameters()
    if let center = mapView.currentViewpoint(with: .centerAndScale)?.targetGeometry as? AGSPoint {
        params.preferredSearchLocation = center
    }
    
    locator.geocode(with: suggestion, parameters: params) { results, error in
        guard error == nil else {
            print("Error performing search from suggestion \(suggestion.label)! \(error!.localizedDescription)")
            return
        }
        
        if let result = results?.first {
            // Do something with the result...
        } else {
            print("\"\(searchText)\" returned no results.")
        }
    }
}
```

## Reverse Geocoding
The Map App uses the built-in map magnifier to help users fine tune a location on the map for reverse geocoding. The magnifier appears after a long-press on the map view. Once the long-press is released, the map point is reverse geocoded.

On long press                          | Reverse geocode result
:-------------------------------------:|:-------------------------------------:
![](/docs/images/app-reverse-geocode-magnifier.png)              | ![](/docs/images/app-reverse-geocode-result.png)

By default the ArcGIS Runtime SDK for iOS will display the magnifier on a long press. We’ve told the `AGSMapView` touch delegate to do a reverse geocode when the long press ends.

``` Swift
func viewDidLoad() {
    super.viewDidLoad()

    // ... set up the Maps App Map View Controller ...

    mapView.touchDelegate = self
}

func geoView(_ geoView: AGSGeoView, didEndLongPressAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
    locator.reverseGeocode(withLocation: mapPoint) { results, error in
        guard error == nil else {
            print("Error reverse geocoding from \(mapPoint): \(error!.localizedDescription)")
            return
        }
        
        guard let result = results?.first else {
            return
        }

        // Do something with the result...        
    }
}
```

## Route
Getting navigation directions in the maps-app is just as easy in the [Runtime SDK](https://developers.arcgis.com/features/directions/) as it is on [ArcGIS Online](http://doc.arcgis.com/en/arcgis-online/use-maps/get-directions.htm). You can [customize](http://doc.arcgis.com/en/arcgis-online/administer/configure-services.htm#ESRI_SECTION1_567C344D5DEE444988CA2FE5193F3CAD) your navigation service for your organization, add new travel modes that better reflect your organization’s workflows, or remove travel modes that are not suitable for your organization’s workflows.

Navigating from point to point in the Map App is enabled by first geocoding or reverse geocoding a location. You can then get directions to that location from the current GPS location (or if GPS is disabled, from the center of the map). In the maps-app, routing requires you to provide credentials to your Portal or ArcGIS Online organization. As mentioned earlier in the Identity section above, we use the `AGSOAuthConfiguration` object to manage the authentication process.

``` Swift
if let routeTaskURL = portal.portalInfo?.helperServices?.routeServiceURL {
    routeTask = AGSRouteTask(url: routeTaskURL)
}
```
You can instantiate a new RouteParameters object by using the `defaultRouteParameters()` method on your `AGSRouteTask` object. Using this method will set the appropriate default settings for routing, add the stops and request route directions, and allow the units of measure for the directions to be specified. The default parameters are loaded when the AGSRouteTask loads, and are cached for subsequent calls, so once the AGSRouteTask has loaded its metadata once from the REST service, the following code will move immediately on to solving the route:

``` Swift
func requestRoute(from:AGSStop, to:AGSStop) {
    routeTask.defaultRouteParameters() { defaultParams, error in
        guard error == nil else {
            print("Error getting default parameters: \(error!.localizedDescription)")
            return
        }
        
        // To make best use of the service, we will base our request off the service's default parameters.
        guard let params = defaultParams else {
            print("No default parameters available.")
            return
        }
        
        params.returnStops = true
        params.returnDirections = true
        params.returnRoutes = true
        params.setStops([from,to])
        params.outputSpatialReference = mapView.spatialReference

        self.routeTask.solveRoute(with: params) { result, error in
            guard error == nil else {
                print("Error solving route between \(from) and \(to): \(error!.localizedDescription)")
                return
            }
            
            guard let routeResult = result?.routes.first else {
                print("Route result unexpectedly empty between \(from) and \(to)")
                return
            }

            // Do something with the route result            
        }
    }
    
}
```
The resulting route is shown:

![](/docs/images/app-directions-result.png)
