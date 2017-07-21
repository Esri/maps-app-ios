//
//  PortalItemCollectionViewDelegate.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

@objc
protocol PortalItemCollectionViewDelegate {
    var items:[AGSPortalItem]? { get }
    
    func portalItemSelected(item:AGSPortalItem)
}
