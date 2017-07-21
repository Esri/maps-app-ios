//
//  AccountDetailsViewController+PortalItemsCollectionView.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension AccountDetailsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Add this function to any ViewController embedding a PortalItemCollectionViewController in
        // the prepareForSegue() method.
        if let portalItemsCollectionVC = segue.destination as? PortalItemCollectionViewController {
            portalItemsCollectionVC.portalItemDelegate = self
            
            // We'll keep a handle to this to update the content when the current folder changes.
            contentVC = portalItemsCollectionVC
        }
    }
}

extension AccountDetailsViewController: PortalItemCollectionViewDelegate {
    var items: [AGSPortalItem]? {
        return mapsAppContext.currentFolder?.webMaps
    }
    
    func portalItemSelected(item: AGSPortalItem) {
        mapsAppContext.currentItem = item
    }
}

