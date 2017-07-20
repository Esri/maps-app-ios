//
//  MapsAppDelegate+AppStartup.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/14/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension MapsAppDelegate {
    
    // MARK: App start
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // License the runtime
        do {
            try AGSArcGISRuntimeEnvironment.setLicenseKey(AppSettings.licenseKey)
        } catch {
            print("Error licensing app: \(error.localizedDescription)")
        }
        print("ArcGIS Runtime License: \(AGSArcGISRuntimeEnvironment.license())")
        
        mapsAppContext.setInitialPortal()
        
        return true
    }

}
