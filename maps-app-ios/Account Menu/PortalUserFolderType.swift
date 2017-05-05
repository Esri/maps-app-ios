//
//  PortalUserFolderType.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/5/17.
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
