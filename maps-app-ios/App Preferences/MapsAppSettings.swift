//
//  MapsAppSettings.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

struct MapsAppSettings {
    static let licenseKey:String = (Bundle.main.infoDictionary?["AGSLicenseKey"] as? String) ?? ""
    static let clientID:String = (Bundle.main.infoDictionary?["AppClientID"] as? String) ?? ""

    static let appSchema:String = "maps-app-ios"
    static let authURLPath:String = "auth"
    static let worldRoutingServiceURL = URL(string: "https://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World")!
    static let worldGeocoderURL = URL(string:"https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer")!
}
