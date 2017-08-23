//
//  MapsAppPreferences.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//
//  A focused wrapper around app-specific preferences.

import ArcGIS

fileprivate enum AppPreferenceKey: String {
    case map
    case viewpoint
    case portalURL
}

class AppPreferences: AGSAppPreferences {
    var map:AGSMap? {
        get {
            return self.getAGS(type: AGSMap.self, forKey: AppPreferenceKey.map)
        }
        set {
            self.setAGS(agsObject: newValue, withKey: AppPreferenceKey.map)
        }
    }
    
    var viewpoint:AGSViewpoint? {
        get {
            return self.getAGS(type: AGSViewpoint.self, forKey: AppPreferenceKey.viewpoint)
        }
        set {
            self.setAGS(agsObject: newValue, withKey: AppPreferenceKey.viewpoint)
        }
    }
    
    var portalURL:URL? {
        get {
            return getURL(forKey: AppPreferenceKey.portalURL)
        }
        set {
            set(value: newValue, forKey: AppPreferenceKey.portalURL)
        }
    }
}
