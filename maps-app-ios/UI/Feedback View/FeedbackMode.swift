//
//  FeedbackMode.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/30/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

typealias FeedbackMode = MapViewMode

extension FeedbackMode {
    var segueName: String {
        return "\(simpleDescription)Segue"
    }
}
