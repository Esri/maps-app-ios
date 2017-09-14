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

import Foundation

infix operator ~==

extension MapViewMode: Equatable {
    static func ==(lhs:MapViewMode, rhs:MapViewMode) -> Bool {
        switch (lhs,rhs) {
        case (.none,.none), (.search,.search):
            return true
        case let (.routeResult(lResult),.routeResult(rResult)):
            return lResult.isEqual(rResult)
        case let (.geocodeResult(lResult), .geocodeResult(rResult)):
            return lResult.isEqual(rResult)
        default:
            return false
        }
    }
    
    static func ~==(lhs:MapViewMode, rhs:MapViewMode) -> Bool {
        // A more loose equality where we just care that it's the same mode, but not the same associated object.
        switch (lhs,rhs) {
        case (.none,.none), (.search,.search), (.routeResult,.routeResult), (.geocodeResult, .geocodeResult):
            return true
        default:
            return false
        }
    }
}
