//
//  AppDelegate.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/24/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

// MARK: Global Shortcut References
var mapsApp:MapsAppDelegate {
    return UIApplication.shared.delegate as! MapsAppDelegate
}

var mapsAppPrefs:AppPreferences {
    return mapsApp.preferences
}

var mapsAppContext:AppContext {
    return mapsApp.state
}

var mapsAppAGSServices:AppAGSServices {
    return mapsApp.agsServices
}

// MARK: Maps App
@UIApplicationMain
class MapsAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: Configuration and Preferences
    fileprivate var preferences = AppPreferences()
    fileprivate var state:AppContext = AppContext()
    fileprivate var agsServices:AppAGSServices = AppAGSServices()
    
    func showDefaultAlert(title:String? = nil, message:String, okButtonText:String = "OK") {
        if let currentViewController = window?.rootViewController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okButtonText, style: .default))
            currentViewController.present(alert, animated: true)
        }
    }
    
    // MARK: App start and licensing
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // License the runtime
        do {
            try AGSArcGISRuntimeEnvironment.setLicenseKey(AppSettings.licenseKey)
        } catch {
            print("Error licensing app: \(error.localizedDescription)")
        }
        print("ArcGIS Runtime License: \(AGSArcGISRuntimeEnvironment.license())")

        setInitialPortal()
        
        return true
    }

    // MARK: OAuth
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return handlePortalAuthOpenURL(app, open: url, options: options)
    }
    
    // MARK: iOS Application Lifecycle
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
}
