//
//  RoundedView.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/18/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

@IBDesignable
public class RoundedView: UIView {
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            setLayerProperties()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var circular: Bool = false {
        didSet {
            setLayerProperties()
        }
    }
    
    @IBInspectable var shadow:Bool = false {
        didSet {
            setLayerProperties()
        }
    }
    
    private func setLayerProperties() {
        layer.cornerRadius = circular ? self.bounds.width/2 : cornerRadius
        
        if shadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 3
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.masksToBounds = false
        } else {
            layer.shadowColor = UIColor.clear.cgColor
            layer.shadowOpacity = 1
            layer.shadowRadius = 0
            layer.masksToBounds = layer.cornerRadius > 0
        }
    }
}
