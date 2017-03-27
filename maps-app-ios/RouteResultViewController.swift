//
//  RouteResultViewController.swift
//  VCTesting
//
//  Created by Nicholas Furness on 3/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
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

                let durationFormatter = DateComponentsFormatter()
                durationFormatter.unitsStyle = .short
                durationFormatter.allowedUnits = [.hour, .minute]
                durationFormatter.allowsFractionalUnits = false
                let time = durationFormatter.string(from: result.totalTime*60) ?? ""
                
                let distanceFormatter = MeasurementFormatter()
                distanceFormatter.unitOptions = .naturalScale
                distanceFormatter.unitStyle = .long
                distanceFormatter.numberFormatter.numberStyle = .decimal
                distanceFormatter.numberFormatter.maximumFractionDigits = 1
                let distance = distanceFormatter.string(from: Measurement(value: result.totalLength, unit: UnitLength.meters))
                
                self.summaryLabel.text = "\(time) (\(distance))"
            }
        }
    }
}
