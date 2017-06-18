//
//  RoundedButton.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

@IBDesignable
public class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            setRadius()
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
            setRadius()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        setRadius()
    }

    private func setRadius() {
        layer.cornerRadius = circular ? self.bounds.width/2 : cornerRadius
        layer.masksToBounds = layer.cornerRadius > 0
    }
}
