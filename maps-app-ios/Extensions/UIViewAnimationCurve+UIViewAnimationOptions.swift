//
//  UIViewAnimationCurve+UIViewAnimationOptions.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/30/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension UIViewAnimationCurve {
    var correspondingAnimationOption:UIViewAnimationOptions {
        switch self {
        case .linear:
            return UIViewAnimationOptions.curveLinear
        case .easeIn:
            return UIViewAnimationOptions.curveEaseIn
        case .easeOut:
            return UIViewAnimationOptions.curveEaseOut
        case .easeInOut:
            return UIViewAnimationOptions.curveEaseInOut
        }
    }
}

