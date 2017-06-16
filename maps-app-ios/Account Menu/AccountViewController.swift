//
//  AccountViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var loggedInContainer: UIView!
    @IBOutlet weak var loggedOutContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.AppLogin, object: nil, queue: nil) { notification in
            self.setLoginUI()
        }
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.AppLogout, object: nil, queue: nil) { notification in
            self.setLoginUI()
        }
        
        setLoginUI()
    }
    
    func setLoginUI() {
        switch mapsAppState.loginStatus {
        case .loggedOut:
            loggedOutContainer.isHidden = false
        case .loggedIn:
            loggedOutContainer.isHidden = true
        }
        loggedInContainer.isHidden = !loggedOutContainer.isHidden
    }
    
    @IBAction func closePanel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
