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

private var autoPanSequence:[AGSLocationDisplayAutoPanMode] = [
    .off,
    .recenter,
    .compassNavigation
]

extension AGSLocationDisplayAutoPanMode {
    func next() -> AGSLocationDisplayAutoPanMode {
        // Cycle through the AutoPan modes this app wants to use...
        let newIndex = ((autoPanSequence.firstIndex(of: self) ?? -1) + 1) % autoPanSequence.count
        return autoPanSequence[newIndex]
    }
}

extension AGSLocationDisplay {
    func getImage() -> UIImage {
        switch self.autoPanMode {
        case .off:
            return self.started ? #imageLiteral(resourceName: "GPS NoFollow") : #imageLiteral(resourceName: "GPS Off")
        case .recenter:
            return #imageLiteral(resourceName: "GPS Follow")
        case .navigation:
            return #imageLiteral(resourceName: "GPS Follow")
        case .compassNavigation:
            return #imageLiteral(resourceName: "GPS Compass")
        @unknown default:
            fatalError("Unsupported enum case.")
        }
    }
}
