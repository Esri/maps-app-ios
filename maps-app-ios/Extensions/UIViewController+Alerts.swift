//
//  UIViewController+Alerts.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/27/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension UIViewController {
    func warnAboutLoginIfLoggedOut(message: String, continueHandler: @escaping (()->Void), cancelHandler: (()->Void)? = nil) {
        if mapsAppState.isLoggedIn {
            continueHandler()
        } else {
            let alert = UIAlertController(title: "Login Required", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in continueHandler() }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in cancelHandler?() }))
            self.present(alert, animated: true)
        }
    }
    
    func showError(title:String, message:String) {
        print("\(title): \(message)")
        showDefaultAlert(title: title, message: message)
    }

    func showDefaultAlert(title:String? = nil, message:String, okButtonText:String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okButtonText, style: .default))
        self.present(alert, animated: true)
    }
}
