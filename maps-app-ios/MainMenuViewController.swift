//
//  MainMenuViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/24/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS
import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var loggedInView: UIStackView!
    @IBOutlet weak var loggedOutView: UIStackView!
    
    @IBOutlet weak var userThumbnailView: UIImageView!
    @IBOutlet weak var userNameView: UILabel!
    
    private var loginStatus:LoginStatus {
        get {
            return mapsApp.loginStatus
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLoginUI()
        
        userThumbnailView.layer.cornerRadius = userThumbnailView.frame.size.width/2
        userThumbnailView.layer.borderColor = UIColor.darkGray.cgColor
        userThumbnailView.layer.borderWidth = 3
        userThumbnailView.clipsToBounds = true
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("MapsAppLogin"), object: nil, queue: nil) { notification in
            self.setLoginUI()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("MapsAppLogout"), object: nil, queue: nil) { notification in
            self.setLoginUI()
        }
    }
    
    private func setLoginUI() {
        switch self.loginStatus {
        case .loggedOut:
            loggedInView.isHidden = true
        case .loggedIn(let loggedInUser):
            loggedInView.isHidden = false
            loggedInUser.thumbnail?.load() { _ in
                self.userThumbnailView.image = loggedInUser.thumbnail?.image ?? #imageLiteral(resourceName: "User")
            }
            userNameView.text = loggedInUser.fullName ?? "Jack Doegerman"
        }
        loggedOutView.isHidden = !loggedInView.isHidden
    }
    
    @IBAction func logIn(_ sender: Any) {
        mapsApp.logIn(portalURL: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        mapsApp.logOut()
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePanel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
