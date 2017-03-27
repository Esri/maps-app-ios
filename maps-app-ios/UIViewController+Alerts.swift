//
//  UIViewController+Alerts.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 3/27/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension UIViewController {
    func showDefaultAlert(title:String? = nil, message:String, okButtonText:String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okButtonText, style: .default))
        self.present(alert, animated: true)
    }
}
