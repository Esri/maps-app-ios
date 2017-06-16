//
//  PortalItemCollectionCell.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/2/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

class PortalItemCollectionCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    
    var item:AGSPortalItem? {
        didSet {
            self.thumbnailView.image = #imageLiteral(resourceName: "Loading Item Image")
            item?.thumbnail?.load() { error in
                if let error = error {
                    print("Couldn't get thumb for Portal Item Cell: \(error.localizedDescription)")
                }
                self.thumbnailView.image = self.item!.thumbnail?.image ?? #imageLiteral(resourceName: "Default Item Image")
            }
            
            itemTitle.text = item?.title ?? "Unknown Item"
            
            thumbnailView.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
}

