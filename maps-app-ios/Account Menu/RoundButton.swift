//
//  RoundButton.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.bounds.width/2
        layer.masksToBounds = layer.cornerRadius > 0
    }
}
