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

class RouteResultViewController : UIViewController {
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var routeResult:AGSRoute? {
        didSet {
            // Here we want to set the route results.
            
            if let result = routeResult {
                if let from = result.stops.first {
                    self.fromLabel.text = from.name
                }
                
                if let to = result.stops.last {
                    self.toLabel.text = to.name
                }

                let time = durationFormatter.string(from: result.totalTime*60) ?? ""
                
                let distance = distanceFormatter.string(from: Measurement(value: result.totalLength, unit: UnitLength.meters))
                
                self.summaryLabel.text = "\(distance) ∙ \(time)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapsAppNotifications.observeRouteSolvedNotification(owner: self) { [weak self] route in
            self?.routeResult = route
        }
    }
    
    deinit {
        MapsAppNotifications.deregisterNotificationBlocks(forOwner: self)
    }

    @IBAction func summaryTapped(_ sender: Any) {
        MapsAppNotifications.postMapViewResetExtentForModeNotification()
    }
    
    private lazy var durationFormatter:DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute]
        formatter.allowsFractionalUnits = false
        return formatter
    }()
    
    private lazy var distanceFormatter:MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.unitStyle = .long
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter
    }()
}
