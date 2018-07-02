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

fileprivate let navigationPropertyKey = #keyPath(AGSMapView.isNavigating)

extension MapViewController {
    func setupAppPreferences() {
        // Load the stored viewpoinrt from preferences if available.
        if let storedViewpoint = mapsAppPrefs.viewpoint {
            mapView.setViewpoint(storedViewpoint)
        }

        // Save the viewpoint to preferences whenever the map stops navigating.
        self.mapView.addObserver(self, forKeyPath: navigationPropertyKey, options: [.new], context: nil)
    }
    
    func observeValueForPreferences(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let target = object as? AGSMapView, keyPath == navigationPropertyKey, let navigating = change?[.newKey] as? Bool, navigating == false {
            DispatchQueue.main.async {
                mapsAppPrefs.viewpoint = target.currentViewpoint(with: .centerAndScale)
            }
        }
    }
}
