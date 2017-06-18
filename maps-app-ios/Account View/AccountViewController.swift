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
        
        showAccountPanelForLoginStatus()
        
        setupLoginNotificationHandlers()
    }
    
    func showAccountPanelForLoginStatus() {
        switch mapsAppState.loginStatus {
        case .loggedOut:
            loggedOutContainer.isHidden = false
        case .loggedIn:
            loggedOutContainer.isHidden = true
        }
        loggedInContainer.isHidden = !loggedOutContainer.isHidden
    }
    
    func setupLoginNotificationHandlers() {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.AppLogin, object: nil, queue: nil) { notification in
            self.showAccountPanelForLoginStatus()
        }
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.AppLogout, object: nil, queue: nil) { notification in
            self.showAccountPanelForLoginStatus()
        }
    }
    
    @IBAction func closePanel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
