//
//  MapsAppGlobals.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/14/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

// MARK: Global Shortcut References
var mapsApp:MapsAppDelegate {
    return UIApplication.shared.delegate as! MapsAppDelegate
}

var mapsAppPrefs:AppPreferences {
    return mapsApp.preferences
}

var mapsAppContext:AppContext {
    return mapsApp.appContext
}

var arcGISServices:ArcGISServices {
    return mapsApp.arcGISServices
}
