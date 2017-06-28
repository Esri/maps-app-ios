//
//  AGSDirectionManeuver+UIImage.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/27/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension AGSDirectionManeuver {
    var image:UIImage {
        get {
            return UIImage(named: "\(self.maneuverType)")!
        }
    }
}
