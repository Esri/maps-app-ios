//
//  PortalUserFolder.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/3/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

enum PortalUserFolderType: Hashable, Equatable, CustomStringConvertible {
    case rootFolder(subFolders:[AGSPortalFolder])
    case folder(agsFolder: AGSPortalFolder)
    
    var hashValue: Int {
        switch self {
        case .rootFolder:
            return 0
        case .folder(let agsFolder):
            return agsFolder.hash
        }
    }
    
    static func ==(lhs:PortalUserFolderType, rhs:PortalUserFolderType) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var description: String {
        switch self {
        case .rootFolder: return "Root Folder"
        case .folder(let folder): return folder.title ?? "Unknown"
        }
    }
    
    var isRoot:Bool {
        switch self {
        case .rootFolder:
            return true
        default:
            return false
        }
    }
}

class PortalUserFolder: AGSLoadableBase {
    let user:AGSPortalUser
    let containerType:PortalUserFolderType
    var subFolders:[PortalUserFolder]? = nil
    var items:[AGSPortalItem] = []
    var webMaps:[AGSPortalItem] {
        get {
            return items.filter() { $0.type == .webMap }
        }
    }
    
    static func rootFolder(forUser user:AGSPortalUser) -> PortalUserFolder {
        return PortalUserFolder(user: user, type: .rootFolder(subFolders: []))
    }
    
    init(user:AGSPortalUser, type:PortalUserFolderType) {
        self.user = user
        self.containerType = type
    }
    
    override var hashValue: Int {
        return containerType.hashValue
    }
    
    static func ==(lhs:PortalUserFolder, rhs:PortalUserFolder) -> Bool {
        return lhs.containerType == rhs.containerType
    }
    
    override func doStartLoading(_ retrying: Bool) {
        loadFromPortal()
    }
    
    var title:String {
        switch self.containerType {
        case .rootFolder:
            return "Root Folder"
        case .folder(let agsFolder):
            return agsFolder.title ?? "No Folder Name"
        }
    }
    
    private func loadFromPortal() {
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
}
