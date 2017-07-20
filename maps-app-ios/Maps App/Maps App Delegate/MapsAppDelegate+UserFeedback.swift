//
//  MapsAppDelegate+UserFeedback.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/14/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension MapsAppDelegate {
    
    // MARK: Alerts
    /**
        Show an application-level alert to the user with a single okButtonText
        
        - Parameters:
            - title: An optional string to show for the alert title.
            - message: A message to display.
            - buttonText: Text for the single default button. Defaults to "OK"
    */
    func showDefaultAlert(title:String? = nil, message:String, buttonText:String = "OK") {
        if let currentViewController = window?.rootViewController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonText, style: .default))
            currentViewController.present(alert, animated: true)
        }
    }
    
    /**
        Show an application-level error message with a single default dismiss button. Also log it appropriately.
    */
    func showError(title:String, message:String) {
        // Here we simply log the message to the console. Replace this with your logging system.
        print("\(title): \(message)")
        showDefaultAlert(title: title, message: message)
    }

    /**
        Warn the user that the action they're attempting to perform requires a login and give them the option to abort the action.
     
        - Parameters:
            - explanation: A message explaining why the action requires the user to be logged in. Also specify any points of interest (such as that the action will consume ArcGIS Online credits, for example).
            - continueHandler: A callback block that is called if the user opts to login and continue with the action.
            - cancelHandler: A callback block that is called if the user opts not to continue with the action.
    */
    func requestConfirmationIfLoggedOut(explanation: String, continueHandler: @escaping (()->Void), cancelHandler: (()->Void)? = nil) {
        if mapsAppContext.isLoggedIn {
            // If the user is already logged in, the block will be called immediately.
            continueHandler()
        } else {
            // Present a warning message if the user is not logged in before performing the block or canceling the action.
            if let currentViewController = window?.rootViewController {
                let alert = UIAlertController(title: "Login Required", message: explanation, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in continueHandler() }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in cancelHandler?() }))
                currentViewController.present(alert, animated: true)
            }
        }
    }
    
    
    // MARK: Progress Spinner
    /**
        Show application-level spinner for long operations.
     
        - Parameters:
            - status: The status string to display with the spinner.
    */
    func showProgressFeedback(status:String) {
        SVProgressHUD.show(withStatus: status)
    }
    
    /**
        Dismiss the application-level spinner.
    */
    func dismissProgressFeedback() {
        SVProgressHUD.dismiss()
    }
    
}
