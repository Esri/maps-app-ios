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

enum MapViewMode {
    case none
    case search
    case routeResult(AGSRoute)
    case geocodeResult(AGSGeocodeResult)
}

extension MapViewMode: CustomStringConvertible {
    var description: String {
        return simpleDescription
    }
    
    var simpleDescription: String {
        switch self {
        case .none:
            return "none"
        case .search:
            return "Search"
        case .routeResult:
            return "RouteResult"
        case .geocodeResult:
            return "GeocodeResult"
        }
    }
    
    var humanReadableDescription: String {
        switch self {
        case .geocodeResult(let result):
            return "Geocode \"\(result.label)\""
        case .routeResult(let route):
            return "Route \(route.routeName)".replacingOccurrences(of: " - ", with: " to ")
        default:
            return "\(self)"
        }
    }
    
    var shortHumanReadableDescription: String {
        switch self {
        case .geocodeResult:
            return "Geocode Result"
        case .routeResult:
            return "Route Result"
        default:
            return "\(self)"
        }
    }
}
