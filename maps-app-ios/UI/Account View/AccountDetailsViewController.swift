// Copyright 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import ArcGIS

class AccountDetailsViewController: UIViewController {

    @IBOutlet weak var userThumbnailView: UIImageView!
    @IBOutlet weak var fullNameView: UILabel!
    @IBOutlet weak var folderButton: UIButton!
    
    var signedInUser:AGSPortalUser? {
        get {
            return mapsAppContext.currentUser
        }
    }

    weak var contentVC:PortalItemCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoginNotificationHandlers()
        setupFolderChangeNotificationHandlers()
        
        setDisplayForLoginStatus()
    }
    
    deinit {
        MapsAppNotifications.deregisterNotificationBlocks(forOwner: self)
    }
    
    func setupLoginNotificationHandlers() {
        MapsAppNotifications.observeLoginStateNotifications(owner: self,
            loginHandler: { [weak self] _ in
                self?.setDisplayForLoginStatus()
            },
            logoutHandler: { [weak self] in
                self?.setDisplayForLoginStatus()
            })
    }
    
    func setupFolderChangeNotificationHandlers() {
        MapsAppNotifications.observeCurrentFolderChangedNotification(owner: self) { [weak self] in self?.showContent() }
    }
    
    func setDisplayForLoginStatus() {
        showUser()
        showContent()
    }
    
    // MARK: UI Display
    private func showUser() {
        fullNameView.text = signedInUser?.fullName ?? "Unknown User"
        signedInUser?.thumbnail?.load() { [weak self] _ in
            self?.userThumbnailView.image = self?.signedInUser?.thumbnail?.image ?? #imageLiteral(resourceName: "User")
        }
    }
    
    private func showContent() {
        if let folder = mapsAppContext.currentFolder {
            self.folderButton.setTitle(folder.title, for: .normal)
            folder.load { [weak self] error in
                guard error == nil else {
                    print("Error loading currentFolder content: \(error!.localizedDescription)")
                    return
                }
                
                self?.contentVC?.items = folder.webMaps
            }
        } else {
            self.contentVC?.items = []
        }
    }
    
    func showFolderPicker() {
        mapsAppContext.rootFolder?.load() { [weak self] error in
            guard let self = self else { return }

            let picker = UIAlertController(title: "Select Folder", message: nil, preferredStyle: .actionSheet)
            picker.addAction(UIAlertAction(title: "Root Folder", style: .default, handler: { _ in
                mapsAppContext.currentFolder = mapsAppContext.rootFolder
            }))

            defer {
                picker.popoverPresentationController?.sourceView = self.folderButton
                picker.popoverPresentationController?.sourceRect = self.folderButton.imageView?.bounds ?? self.folderButton.bounds
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
    @IBAction func signOut(_ sender: Any) {
        mapsAppContext.signOut()
    }
    
    @IBAction func folderNameTapped(_ sender: Any) {
        showFolderPicker()
    }
}
