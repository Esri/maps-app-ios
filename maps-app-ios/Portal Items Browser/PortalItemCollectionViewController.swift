//
//  PortalItemCollectionViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/1/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

class PortalItemCollectionViewController: UICollectionViewController {
    var items:[AGSPortalItem] = [] {
        didSet {
            collectionView?.reloadData()
            collectionView?.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortalItem", for: indexPath)
        
        if let cell = cell as? PortalItemCollectionCell, indexPath.row <= items.count {
            cell.item = items[indexPath.row]
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // This will get called during the Unwind Segue that each PortalItemCollectionCell triggers.
        super.prepare(for: segue, sender: sender)

        // Tell the mapsApp that we've picked a web map to open.
        mapsAppContext.currentItem = (sender as? PortalItemCollectionCell)?.item
    }
}

extension PortalItemCollectionViewController: UICollectionViewDataSourcePrefetching {
    // Remember to write up the prefetchDelegtate in the Storyboard
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let item = items[indexPath.row]
            item.thumbnail?.load() { error in
                if let error = error {
                    print("Error pre-fetching portal item at index \(indexPath.row): \(error.localizedDescription)")
                }
            }
        }
    }
}
