//
//  AGSLocationDisplay+MapsApp.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/5/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

private var autoPanSequence:[AGSLocationDisplayAutoPanMode] = [
    .off,
    .recenter,
    .compassNavigation
]

extension AGSLocationDisplayAutoPanMode {
    func next() -> AGSLocationDisplayAutoPanMode {
        // Cycle through the AutoPan modes this app wants to use...
        let newIndex = ((autoPanSequence.index(of: self) ?? -1) + 1) % autoPanSequence.count
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
        }
    }
}
