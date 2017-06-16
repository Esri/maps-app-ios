//
//  AccountDetailsViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/24/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS
import UIKit

class AccountDetailsViewController: UIViewController {

    @IBOutlet weak var userThumbnailView: UIImageView!
    @IBOutlet weak var fullNameView: UILabel!
    @IBOutlet weak var folderButton: UIButton!
    @IBOutlet weak var portalItemsView: UIStackView!
    
    var loggedInUser:AGSPortalUser? {
        get {
            return mapsAppState.currentUser
        }
    }
    
    var subFolders:[PortalUserFolder] {
        return mapsAppState.rootFolder?.subFolders ?? []
    }
    
    var contentVC:PortalItemCollectionViewController? {
        return self.childViewControllers.filter({ $0 is PortalItemCollectionViewController }).first as? PortalItemCollectionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userThumbnailView.layer.cornerRadius = userThumbnailView.frame.size.width/2
        userThumbnailView.layer.borderColor = UIColor.darkGray.cgColor
        userThumbnailView.layer.borderWidth = 3
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.CurrentFolderChanged, object: nil, queue: nil) { notification in
            self.showContent()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        if let folder = mapsAppState.currentFolder {
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
        mapsAppState.rootFolder?.load() { error in
            let picker = UIAlertController(title: "Select Folder", message: nil, preferredStyle: .actionSheet)
            
            defer {
                self.present(picker, animated: true, completion: nil)
            }
            
            picker.addAction(UIAlertAction(title: "Root Folder", style: .default, handler: { _ in
                mapsAppState.currentFolder = mapsAppState.rootFolder
            }))
            
            guard error == nil else {
                picker.addAction(UIAlertAction(title: "Error loading subfolders!", style: .cancel, handler: nil))
                print("Error loading subfolders: \(error!.localizedDescription)")
                return
            }
            
            if let subFolders = mapsAppState.rootFolder?.subFolders {
                for folder in subFolders {
                    let folderAction = UIAlertAction(title: folder.title, style: .default, handler: { action in
                        mapsAppState.currentFolder = folder
                    })
                    picker.addAction(folderAction)
                }
            }
        }
    }

    // MARK: UI Actions
    @IBAction func logOut(_ sender: Any) {
        mapsApp.logOut()
    }
    
    @IBAction func folderNameTapped(_ sender: Any) {
        showFolderPicker()
    }
    
    // MARK: Exit Segues
    @IBAction func closeMainMenu(_ segue:UIStoryboardSegue) {
        // Unwind/Exit segue target
        self.dismiss(animated: true, completion: nil)
    }
}
