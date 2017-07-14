//
//  MapsAppDelegate+UserFeedback.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/14/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension MapsAppDelegate {
    func showDefaultAlert(title:String? = nil, message:String, okButtonText:String = "OK") {
        if let currentViewController = window?.rootViewController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okButtonText, style: .default))
            currentViewController.present(alert, animated: true)
        }
    }
    
    func showError(title:String, message:String) {
        print("\(title): \(message)")
        showDefaultAlert(title: title, message: message)
    }

    func warnAboutLoginIfLoggedOut(message: String, continueHandler: @escaping (()->Void), cancelHandler: (()->Void)? = nil) {
        // This method can present a warning message if the user is not logged in before performing the block.
        // If the user is already logged in, the block will be called immediately.
        if mapsAppContext.isLoggedIn {
            continueHandler()
        } else {
            if let currentViewController = window?.rootViewController {
                let alert = UIAlertController(title: "Login Required", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in continueHandler() }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in cancelHandler?() }))
                currentViewController.present(alert, animated: true)
            }
        }
    }
}
