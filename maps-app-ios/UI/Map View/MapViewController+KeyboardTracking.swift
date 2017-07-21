//
//  MapViewController+KeyboardTracking.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/30/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension MapViewController {
    func setupMapViewAttributeBarTracking(activate:Bool) {
        // Set up a constraint between the MapView's attribution panel and the bottom of our UI.
        attributeAnchor = controlsView.bottomAnchor.constraint(lessThanOrEqualTo: mapView.attributionTopAnchor, constant: -12)
        attributeAnchor?.isActive = activate
    }
    
    func setupKeyboardTracking(activate:Bool) {
        // Set up a constraint between the a special view used to align with the keyboard, and our UI.
        keyboardAnchor = controlsView.bottomAnchor.constraint(equalTo: keyboardSpacer.topAnchor, constant: -12)
        keyboardAnchor?.isActive = activate
    }
    
    func activateKeyboardTracking() {
        // Listen to keyboard notifications.
        for notificationName:Notification.Name in [.UIKeyboardWillShow, .UIKeyboardWillHide] {
            keyboardObservers.append(NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { notification in
                // Set our special view that tracks the keyboard. Either display or hide.
                self.setKeyboardSpacerFromKeyboardNotification(notification: notification)
            })
        }
    }
    
    func deactivateKeyboardTracking() {
        // Stop listening to keyboard notifications.
        for observer in keyboardObservers {
            NotificationCenter.default.removeObserver(observer)
        }
        
        keyboardObservers.removeAll()
    }
    
    private func setKeyboardSpacerFromKeyboardNotification(notification:Notification) {
        // If we got information about the keyboard position (shown or hidden), animate our special tracking UIView
        // to follow the keyboard. Constraints between that view and the rest of our UI will ensure our UI also animates
        // to avoid being hidden by the keyboard.
        if let userInfo = notification.userInfo,
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let rawCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uint32Value,
            let curve = UIViewAnimationCurve(rawValue: Int(rawCurve) << 16) {
            
            let endFrameInContext = view.convert(endFrame, to: self.view)
            let newHeight = view.bounds.maxY - endFrameInContext.minY
            
            UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState, curve.correspondingAnimationOption], animations: {
                if notification.name == .UIKeyboardWillShow {
                    self.attributeAnchor?.isActive = false
                    self.keyboardAnchor?.isActive = true
                } else if notification.name == .UIKeyboardWillHide {
                    self.attributeAnchor?.isActive = true
                    self.keyboardAnchor?.isActive = false
                }
                
                self.keyboardSpacerHeightConstraint.constant = newHeight
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
