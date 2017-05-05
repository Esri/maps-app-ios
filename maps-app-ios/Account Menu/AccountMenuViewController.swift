//
//  AccountMenuViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/24/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS
import UIKit

class AccountMenuViewController: UIViewController {

    @IBOutlet weak var loggedInView: UIStackView!
    @IBOutlet weak var loggedOutView: UIStackView!
    @IBOutlet weak var userThumbnailView: UIImageView!
    @IBOutlet weak var fullNameView: UILabel!
    @IBOutlet weak var folderButton: UIButton!
    @IBOutlet weak var portalItemsView: UIStackView!
    
    private var loginStatus:LoginStatus {
        return mapsApp.loginStatus
    }
    
    var currentFolder:PortalUserFolder? {
        get {
            return mapsApp.currentFolder
        }
        set {
            mapsApp.currentFolder = newValue
        }
    }
    
    var subFolders:[PortalUserFolder] {
        return mapsApp.rootFolder?.subFolders ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userThumbnailView.layer.cornerRadius = userThumbnailView.frame.size.width/2
        userThumbnailView.layer.borderColor = UIColor.darkGray.cgColor
        userThumbnailView.layer.borderWidth = 3
        
        listenToAppNofications()
        
        setLoginUI()
        
        showContent()
    }
    
    private func listenToAppNofications() {
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.AppLogin, object: nil, queue: nil) { notification in
            self.setLoginUI()
        }
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.AppLogout, object: nil, queue: nil) { notification in
            self.setLoginUI()
        }
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.CurrentFolderChanged, object: nil, queue: nil) { notification in
            guard let currentFolder = mapsApp.currentFolder else {
                self.showContent()
                return
            }
            
            self.showContent()
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
            fullNameView.text = loggedInUser.fullName ?? "Unknown User"
        }
        loggedOutView.isHidden = !loggedInView.isHidden
        portalItemsView.isHidden = loggedInView.isHidden
    }
    
    @IBAction func logIn(_ sender: Any) {
        mapsApp.logIn(portalURL: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        mapsApp.logOut()
    }
    
    @IBAction func closePanel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func folderNameTapped(_ sender: Any) {
        showFolderPicker()
    }
    
    func showContent() {
        if let folder = currentFolder {
            self.folderButton.setTitle(folder.title, for: .normal)
            folder.load { error in
                guard error == nil else {
                    print("Error loading currentFolder content: \(error!.localizedDescription)")
                    return
                }
                
                self.contentVC?.items = folder.webMaps
            }
        } else {
            self.contentVC?.items = []
        }
    }
    
    func showFolderPicker() {
        mapsApp.rootFolder?.load() { error in
            let picker = UIAlertController(title: "Select Folder", message: nil, preferredStyle: .actionSheet)
            
            defer {
                self.present(picker, animated: true, completion: nil)
            }
            
            picker.addAction(UIAlertAction(title: "Root Folder", style: .default, handler: { _ in
                self.currentFolder = mapsApp.rootFolder
            }))
            
            guard error == nil else {
                picker.addAction(UIAlertAction(title: "Error loading subfolders!", style: .cancel, handler: nil))
                print("Error loading subfolders: \(error!.localizedDescription)")
                return
            }
            
            if let subFolders = mapsApp.rootFolder?.subFolders {
                for folder in subFolders {
                    let folderAction = UIAlertAction(title: folder.title, style: .default, handler: { action in
                        self.currentFolder = folder
                    })
                    picker.addAction(folderAction)
                }
            }
        }
    }
    
    var contentVC:PortalItemCollectionViewController? {
        get {
            return self.childViewControllers.filter({ $0 is PortalItemCollectionViewController }).first as? PortalItemCollectionViewController
        }
    }
    
    @IBAction func closeMainMenu(_ segue:UIStoryboardSegue) {
        // Unwind/Exit segue target
        self.dismiss(animated: true, completion: nil)
    }
}
