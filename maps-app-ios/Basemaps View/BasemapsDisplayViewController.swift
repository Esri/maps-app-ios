//
//  BasemapsDisplayViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/19/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

import UIKit
import ArcGIS

class BasemapsDisplayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var items:[AGSPortalItem] {
        get {
            return mapsAppState.basemaps
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasemapItem", for: indexPath)
        
        if let cell = cell as? BasemapCollectionCell, indexPath.row <= items.count {
            cell.item = items[indexPath.row]
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // This will get called during the Unwind Segue that each PortalItemCollectionCell triggers.
        super.prepare(for: segue, sender: sender)
        
        // Tell the mapsApp that we've picked a web map to open.
        mapsAppState.currentItem = (sender as? PortalItemCollectionCell)?.item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MapsAppNotifications.postNewBasemapNotification(basemap: items[indexPath.row])
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelBasemapPicker(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension BasemapsDisplayViewController: UICollectionViewDataSourcePrefetching {
    // Remember to write up the prefetchDelegtate in the Storyboard
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let item = items[indexPath.row]
            item.thumbnail?.load() { error in
                if let error = error {
                    print("Error pre-fetching basemap at index \(indexPath.row): \(error.localizedDescription)")
                }
            }
        }
    }
}
