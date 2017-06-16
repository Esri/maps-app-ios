//
//  AccountLoginViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

class AccountLoginViewController: UIViewController {
    @IBAction func logIn(_ sender: Any) {
        mapsApp.logIn(portalURL: nil)
    }
}
