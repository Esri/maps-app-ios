// Copyright 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
        if let currentViewController = window?.rootViewController?.presentedViewController ?? window?.rootViewController {
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
            - explanation: A message explaining why the action requires the user to be signed in. Also specify any points of interest (such as that the action will consume ArcGIS Online credits, for example).
            - continueHandler: A callback block that is called if the user opts to sign in and continue with the action.
            - cancelHandler: A callback block that is called if the user opts not to continue with the action.
    */
    func requestConfirmationIfSignedOut(explanation: String, continueHandler: @escaping (()->Void), cancelHandler: (()->Void)? = nil) {
        if mapsAppContext.isSignedIn {
            // If the user is already signed in, the block will be called immediately.
            continueHandler()
        } else {
            // Present a warning message if the user is not signed in before performing the block or canceling the action.
            if let currentViewController = window?.rootViewController?.presentedViewController ?? window?.rootViewController {
                let alert = UIAlertController(title: "Login Required", message: explanation, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Sign in", style: .default, handler: { _ in continueHandler() }))
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
    func showProgressFeedback(status:String, forView view:UIView? = nil) {
        configHUD(forView: view)
        SVProgressHUD.show(withStatus: status)
    }
    
    /**
        Dismiss the application-level spinner.
    */
    func dismissProgressFeedback() {
        SVProgressHUD.dismiss()
    }
    
    /**
        Show error for progress spinning operation.
    */
    func showProgressError(errorMessage:String, forView view:UIView? = nil) {
        configHUD(forView: view)
        SVProgressHUD.showError(withStatus: errorMessage)
    }
    
    private func configHUD(forView view:UIView?) {
        if let view = view ?? window?.rootViewController?.view {
            SVProgressHUD.setContainerView(view)
        }
        SVProgressHUD.setDefaultMaskType(.black)
    }
}
