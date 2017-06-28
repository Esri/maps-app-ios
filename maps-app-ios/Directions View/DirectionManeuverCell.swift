//
//  DirectionManeuverCell.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/26/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS
import UIKit

class DirectionManeuverCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var maneuverLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var index:Int!
    
    var maneuver:AGSDirectionManeuver? {
        didSet {
            if let maneuver = maneuver, let index = index {
                image.image = maneuver.image
                var text = maneuver.directionText
                
                switch maneuver.maneuverType {
                case .depart, .stop:
                    detailsLabel.text = nil
                default:
                    text = "\(index). \(text)"

                    var durationComponents = DateComponents()
                    durationComponents.minute = Int(maneuver.duration)
                    let duration = (durationComponents.minute ?? 0 > 0) ? DirectionManeuverCell.durationFormatter.string(from: durationComponents) : nil
                    let distance = DirectionManeuverCell.distanceFormatter.string(from: Measurement(value: maneuver.length, unit: UnitLength.meters).converted(to: UnitLength.miles))
                    
                    if let duration = duration {
                        detailsLabel.text = "\(distance) ∙ \(duration)"
                    } else {
                        detailsLabel.text = "\(distance)"
                    }
                }

                maneuverLabel.text = text
            } else {
                print("Unexpectedly got a nil maneuver for a cell!")
            }
        }
    }
    
    private static var durationFormatter:DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute]
        formatter.allowsFractionalUnits = false
        formatter.maximumUnitCount = 2
        return formatter
    }()
    
    private static var distanceFormatter:MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit // This is sub-optimal. We want miles only, but need to rely on the locale.
        formatter.unitStyle = .medium
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.maximumFractionDigits = 2
        return formatter
    }()
}


