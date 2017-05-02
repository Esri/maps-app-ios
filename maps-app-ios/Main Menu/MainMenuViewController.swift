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
    @IBOutlet weak var fullNameView: UILabel!
    
    @IBOutlet weak var portalItemsView: UIView!
    
    @IBOutlet weak var folderButton: UIButton!
    
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
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.AppLogin, object: nil, queue: nil) { notification in
            self.setLoginUI()
        }
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.AppLogout, object: nil, queue: nil) { notification in
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
            fullNameView.text = loggedInUser.fullName ?? "Unknown User"
            setCurrentFolderUI()
            getContent()
        }
        loggedOutView.isHidden = !loggedInView.isHidden
    }
    
    @IBAction func logIn(_ sender: Any) {
        mapsApp.logIn(portalURL: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        mapsApp.logOut()
    }
    
    @IBAction func closePanel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var folders:[AGSPortalFolder]? = nil {
        didSet {
            folderButton.isUserInteractionEnabled = (folders?.count ?? 0) > 0
        }
    }
    var folderItems:[AGSPortalItem]? = nil
    var currentFolder:AGSPortalFolder? = nil {
        didSet {
            setCurrentFolderUI()
            if mapsApp.currentUser != nil {
                getContent()
            }
        }
    }
    
    func setCurrentFolderUI() {
        folderButton.setTitle(currentFolder?.title ?? "Root Folder", for: .normal)
    }
    
    @IBAction func folderNameTapped(_ sender: Any) {
        let picker = UIAlertController(title: "Select Folder", message: nil, preferredStyle: .actionSheet)
        
        picker.addAction(UIAlertAction(title: "Root Folder", style: .default, handler: { _ in
            self.currentFolder = nil
        }))
        
        if let folders = folders {
            for folder in folders {
                let folderAction = UIAlertAction(title: folder.title ?? "Unknown Folder", style: .default, handler: { action in
                    self.currentFolder = folder
                })
                picker.addAction(folderAction)
            }
        }
        
        self.present(picker, animated: true, completion: nil)
    }
    
    var cachedContent:PortalContent? = PortalContent()
    
    func getContent() {
        guard let user = mapsApp.currentUser else {
            return
        }
        
        contentVC?.items = []
        
        if let folderID = currentFolder?.folderID {
            user.fetchContent(inFolder: folderID) { items, error in
                guard error == nil else {
                    let username = user.username ?? "Unknown"
                    let title = self.currentFolder?.title ?? "Unknown"
                    print("Error getting portal items for user \(username), folder \(title): \(error!.localizedDescription)")
                    return
                }
                
                self.showContent(items: items)
            }
        } else {
            user.fetchContent() { items, folders, error in
                guard error == nil else {
                    let username = user.username ?? "Unknown"
                    print("Error getting portal items for user \(username): \(error!.localizedDescription)")
                    return
                }
                
                self.folders = folders

                self.showContent(items: items)
                
//                if let folders = folders {
//                    for folder in folders {
//                        if let folderID = folder.folderID {
//                            self.cachedContent?.folders[folderID] = PortalContent.PortalFolder(agsFolder: folder, agsItems: nil)
//                        }
//                    }
//                }
            }
        }
    }
    
    func showContent(items:[AGSPortalItem]?) {
        self.contentVC?.items = items?.filter({ item in
            return item.type == AGSPortalItemType.webMap
        }) ?? []
    }
    
    var contentVC:PortalItemCollectionViewController? {
        get {
            return self.childViewControllers.filter({ $0 is PortalItemCollectionViewController }).first as? PortalItemCollectionViewController
        }
    }
    
    @IBAction func closeMainMenu(_ segue:UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
}

struct PortalContent {
    typealias FolderID = String
    
    struct PortalFolder {
        let agsFolder:AGSPortalFolder
        let agsItems:[AGSPortalItem]?
        
        var webmaps:[AGSPortalItem]? {
            if let items = agsItems {
                return items.filter({ item in
                    return item.type == .webMap
                })
            }
            return nil
        }
    }
    
    var rootItems:[AGSPortalItem]?
    
    var folders:[FolderID:PortalFolder] = [:]
}
