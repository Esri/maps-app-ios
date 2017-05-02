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
        super.prepare(for: segue, sender: sender)

        mapsApp.currentItem = (sender as? PortalItemCollectionCell)?.item
    }
}
