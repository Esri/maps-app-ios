//
//  AppDelegate.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/24/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

private let worldRoutingServiceURL = URL(string: "https://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World")!
private let worldGeocoderURL = URL(string:"https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer")!

@UIApplicationMain
class MapsAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var preferences = MapsAppPreferences()
    
    var locator = AGSLocatorTask(url: worldGeocoderURL)

    var routeTask = AGSRouteTask(url: worldRoutingServiceURL)
    var defaultRouteParameters: AGSRouteParameters?

    var currentPortal:AGSPortal? {
        didSet {
            AGSAuthenticationManager.shared().oAuthConfigurations.removeAllObjects()

            // When the portal switches, update service tasks
            if let portal = currentPortal {
                
                let oauthConfig = AGSOAuthConfiguration(portalURL: portal.url, clientID: MapsAppSettings.clientID, redirectURL: "\(MapsAppSettings.appSchema)://\(MapsAppSettings.authURLPath)")
                AGSAuthenticationManager.shared().oAuthConfigurations.add(oauthConfig)

                portal.load() { error in
                    guard error == nil else {
                        print("Error loading the portal: \(error!.localizedDescription)")
                        return
                    }

                    self.setServicesForPortal(portal: portal)
                    
                    if let user = portal.user {
                        self.loginStatus = .loggedIn(user: user)
                    } else {
                        self.loginStatus = .loggedOut
                    }
                }
            }
        }
    }
    
    var loginStatus:LoginStatus = .loggedOut {
        didSet {
            loginChanged()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return portalAuth(app, open: url, options: options)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // License the runtime
        do {
            try AGSArcGISRuntimeEnvironment.setLicenseKey(MapsAppSettings.licenseKey)
        } catch {
            print("Error licensing app: \(error.localizedDescription)")
        }
        print("ArcGIS Runtime License: \(AGSArcGISRuntimeEnvironment.license())")

        setPortalOnAppStart()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setServicesForPortal(portal:AGSPortal) {
        portal.load { error in
            guard error == nil else {
                print("Error loading the portal: \(error!.localizedDescription)")
                return
            }
            
            if let svcs = portal.portalInfo?.helperServices {
                if let geocoderURL = svcs.geocodeServiceURLs?.first, geocoderURL != self.locator.url {
                    self.locator = AGSLocatorTask(url: geocoderURL)
                }
                
                if let routeTaskURL = svcs.routeServiceURL, routeTaskURL != self.routeTask.url {
                    self.routeTask = AGSRouteTask(url: routeTaskURL)
                }
            }
        }
    }
}

var mapsApp:MapsAppDelegate {
    return UIApplication.shared.delegate as! MapsAppDelegate
}

var mapsAppPrefs:MapsAppPreferences {
    return mapsApp.preferences
}
