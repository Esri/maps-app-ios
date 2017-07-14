//
//  BasemapDisplayViewController+UICollectionView.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/8/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension BasemapsDisplayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mapsAppContext.currentBasemap = items[indexPath.row]
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension BasemapsDisplayViewController: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
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
