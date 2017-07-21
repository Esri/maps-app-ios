//
//  ASGDirectionManeuverType+CustomStringConvertible.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/27/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension AGSDirectionManeuverType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .stop:
            return "Stop"
        case .straight:
            return "Straight"
        case .bearLeft:
            return "BearLeft"
        case .bearRight:
            return "BearRight"
        case .turnLeft:
            return "TurnLeft"
        case .turnRight:
            return "TurnRight"
        case .sharpLeft:
            return "SharpLeft"
        case .sharpRight:
            return "SharpRight"
        case .uTurn:
            return "UTurn"
        case .roundabout:
            return "Roundabout"
        case .forkLeft:
            return "ForkLeft"
        case .forkRight:
            return "ForkRight"
        case .depart:
            return "Depart"
        case .rampRight:
            return "RampRight"
        case .rampLeft:
            return "RampLeft"
        case .turnLeftRight:
            return "TurnLeftRight"
        case .turnRightLeft:
            return "TurnRightLeft"
        case .turnRightRight:
            return "TurnRightRight"
        case .turnLeftLeft:
            return "TurnLeftLeft"
        default:
            return "Unknown"
        }
    }

    var image:UIImage {
        get {
            return UIImage(named: "\(self)")!
        }
    }
}
