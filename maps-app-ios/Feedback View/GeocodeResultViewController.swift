//
//  ReverseGeocodeViewController.swift
//  VCTesting
//
//  Created by Nicholas Furness on 3/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

class GeocodeResultViewController : UIViewController {
    @IBOutlet weak var addressLabel: UILabel!

    var result:AGSGeocodeResult? {
        didSet {
            if let result = self.result {
                self.addressLabel.text = result.label
            }
        }
    }
    
    @IBAction func requestRoute(_ sender: Any) {
        if let destination = result {
            mapsAppAGSServices.route(to: destination)
        }
    }
    
    @IBAction func geocodeResultTapped(_ sender: Any) {
        MapsAppNotifications.postMapViewResetExtentForModeNotification()
    }
}
