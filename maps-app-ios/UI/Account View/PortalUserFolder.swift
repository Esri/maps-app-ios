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

class PortalUserFolder: AGSLoadableBase {
    let user:AGSPortalUser

    let containerType:PortalUserFolderType
    
    var title:String {
        switch self.containerType {
        case .rootFolder:
            return "Root Folder"
        case .folder(let agsFolder):
            return agsFolder.title ?? "No Folder Name"
        }
    }
    
    var subFolders:[PortalUserFolder]? = nil
    var items:[AGSPortalItem] = []
    var webMaps:[AGSPortalItem] {
        return items.filter() { $0.type == .webMap }
    }
    
    init(user:AGSPortalUser, type:PortalUserFolderType) {
        self.user = user
        self.containerType = type
    }
    
    // MARK: AGSLoadable
    override func doStartLoading(_ retrying: Bool) {
        loadItemsFromPortal()
    }
    
    private func loadItemsFromPortal() {
        switch self.containerType {
        case .rootFolder:
            user.fetchContent() { items, folders, error in
                guard error == nil else {
                    self.loadDidFinishWithError(error)
                    return
                }
                
                self.subFolders = (folders ?? []).map({ (agsFolder) -> PortalUserFolder in
                    return PortalUserFolder(user: self.user, type: .folder(agsFolder: agsFolder))
                })
                
                self.items = items ?? []
                self.loadDidFinishWithError(nil)
            }
        case .folder(let agsFolder):
            user.fetchContent(inFolder: agsFolder.folderID) { items, error in
                guard error == nil else {
                    self.loadDidFinishWithError(error)
                    return
                }
                
                self.items = items ?? []
                
                self.loadDidFinishWithError(nil)
            }
        }
    }
    
    // MARK: Hashable
    override var hash: Int {
        return containerType.hashValue
    }
    
    static func ==(lhs:PortalUserFolder, rhs:PortalUserFolder) -> Bool {
        return lhs.containerType == rhs.containerType
    }
    
    // MARK: Static Factory Methods
    static func rootFolder(forUser user:AGSPortalUser) -> PortalUserFolder {
        return PortalUserFolder(user: user, type: .rootFolder(subFolders: []))
    }
}
