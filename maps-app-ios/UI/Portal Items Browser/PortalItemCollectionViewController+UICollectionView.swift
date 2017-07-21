//
//  PortalItemCollectionViewController+UICollectionView.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

extension PortalItemCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PortalItemCollectionCell,
            let portalItem = cell.item else {
                return
        }
        
        portalItemDelegate?.portalItemSelected(item: portalItem)
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

