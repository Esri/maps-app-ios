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

class GeocodeResultViewController : UIViewController {
    @IBOutlet weak var addressLabel: UILabel!

    var result:AGSGeocodeResult? {
        didSet {
            if let result = self.result {
                self.addressLabel.text = result.attributes?["LongLabel"] as? String ?? result.label
            }
        }
    }
    
    @IBAction func requestRoute(_ sender: Any) {
        if let destination = result {
            arcGISServices.route(to: destination)
        }
    }
    
    @IBAction func geocodeResultTapped(_ sender: Any) {
        MapsAppNotifications.postMapViewResetExtentForModeNotification()
    }
}
