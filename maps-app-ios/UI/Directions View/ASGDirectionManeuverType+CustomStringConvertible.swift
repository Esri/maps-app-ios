// Copyright 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
