//
//  AccountLoginViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

fileprivate let signUpURL = URL(string: "https://developers.arcgis.com/sign-up")!

class AccountLoginViewController: UIViewController {
    @IBAction func logIn(_ sender: Any) {
        let portalURL = mapsAppContext.currentPortal?.url
        mapsAppContext.logIn(portalURL: portalURL)
    }
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(signUpURL, options: [:], completionHandler: nil)
    }
}
