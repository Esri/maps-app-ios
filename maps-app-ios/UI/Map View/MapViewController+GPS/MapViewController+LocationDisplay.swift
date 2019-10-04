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

extension MapViewController {
    func setupLocationDisplay() {
        mapView.locationDisplay.navigationPointHeightFactor = 0.4
        
        
        mapView.locationDisplay.start() { error in
            if let error = error {
                mapsApp.showDefaultAlert(title: "Unable to start GPS", message: error.localizedDescription)
            }
        }
        
        mapView.locationDisplay.autoPanModeChangedHandler = { newAutoPanMode in
            DispatchQueue.main.async { [weak self] in
                print("New autoPanMode: \(newAutoPanMode)")
                guard let self = self else { return }
                self.gpsButton.setImage(self.mapView.locationDisplay.getImage(), for: .normal)
            }
        }
    }
    
    @IBAction func nextGPSMode(_ sender: Any) {
        mapView.locationDisplay.autoPanMode = mapView.locationDisplay.autoPanMode.next()
    }
}
