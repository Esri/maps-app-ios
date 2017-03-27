//
//  AGSAppPreferences+Map.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/29/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension AGSAppPreferences {
    var map:AGSMap? {
        get {
            return self.getAGS(type: AGSMap.self, forKey: .map)
        }
        set {
            self.setAGS(agsObject: newValue, withKey: .map)
        }
    }
    
    var viewpoint:AGSViewpoint? {
        get {
            return self.getAGS(type: AGSViewpoint.self, forKey: .viewpoint)
        }
        set {
            self.setAGS(agsObject: newValue, withKey: .viewpoint)
        }
    }
}
