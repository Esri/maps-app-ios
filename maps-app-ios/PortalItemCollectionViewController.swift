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
        
        cell.layer.cornerRadius = 5
        
        return cell
    }
}

class PortalItemCollectionCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    
    var item:AGSPortalItem? {
        didSet {
            item?.thumbnail?.load() { error in
                if let error = error {
                    print("Couldn't get thumb for Portal Item Cell: \(error.localizedDescription)")
                }
                self.thumbnailView.image = self.item!.thumbnail?.image ?? #imageLiteral(resourceName: "Default Item Image")
            }

            itemTitle.text = item?.title ?? "Unknown Item"
        }
    }
}
