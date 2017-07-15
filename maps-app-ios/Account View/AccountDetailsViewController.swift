//
//  AccountDetailsViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/24/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

class AccountDetailsViewController: UIViewController {

    @IBOutlet weak var userThumbnailView: UIImageView!
    @IBOutlet weak var fullNameView: UILabel!
    @IBOutlet weak var folderButton: UIButton!
    
    var loggedInUser:AGSPortalUser? {
        get {
            return mapsAppContext.currentUser
        }
    }

    var contentVC:PortalItemCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoginNotificationHandlers()
        setupFolderChangeNotificationHandlers()
        
        setDisplayForLoginStatus()
    }
    
    func setupLoginNotificationHandlers() {
        MapsAppNotifications.observeLoginStateNotifications(loginHandler: { _ in self.setDisplayForLoginStatus() },
                                                            logoutHandler: { self.setDisplayForLoginStatus() })
    }
    
    func setupFolderChangeNotificationHandlers() {
        MapsAppNotifications.observeCurrentFolderChanged() { self.showContent() }
    }
    
    func setDisplayForLoginStatus() {
        showUser()
        showContent()
    }
    
    // MARK: UI Display
    private func showUser() {
        fullNameView.text = loggedInUser?.fullName ?? "Unknown User"
        loggedInUser?.thumbnail?.load() { _ in
            self.userThumbnailView.image = self.loggedInUser?.thumbnail?.image ?? #imageLiteral(resourceName: "User")
        }
    }
    
    private func showContent() {
        if let folder = mapsAppContext.currentFolder {
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
        mapsAppContext.rootFolder?.load() { error in
            let picker = UIAlertController(title: "Select Folder", message: nil, preferredStyle: .actionSheet)
            picker.addAction(UIAlertAction(title: "Root Folder", style: .default, handler: { _ in
                mapsAppContext.currentFolder = mapsAppContext.rootFolder
            }))

            defer {
                self.present(picker, animated: true, completion: nil)
            }
            
            guard error == nil else {
                picker.addAction(UIAlertAction(title: "Error loading subfolders!", style: .cancel, handler: nil))
                print("Error loading subfolders: \(error!.localizedDescription)")
                return
            }
            
            if let subFolders = mapsAppContext.rootFolder?.subFolders {
                for folder in subFolders {
                    let folderAction = UIAlertAction(title: folder.title, style: .default, handler: { action in
                        mapsAppContext.currentFolder = folder
                    })
                    picker.addAction(folderAction)
                }
            }

            picker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
    }

    // MARK: UI Actions
    @IBAction func logOut(_ sender: Any) {
        mapsApp.logOut()
    }
    
    @IBAction func folderNameTapped(_ sender: Any) {
        showFolderPicker()
    }
}
