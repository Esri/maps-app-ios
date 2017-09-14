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
        loggedOutContainer.isHidden = mapsAppContext.isLoggedIn
        loggedInContainer.isHidden = !loggedOutContainer.isHidden
    }
    
    func setupLoginNotificationHandlers() {
        MapsAppNotifications.observeLoginStateNotifications(loginHandler: { _ in self.showAccountPanelForLoginStatus() },
                                                            logoutHandler: { _ in self.showAccountPanelForLoginStatus() })
    }

    @IBAction func closeAccountViewer(_: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
}
