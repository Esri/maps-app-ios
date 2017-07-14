//
//  BasemapCollectionCell.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/19/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

//class BasemapCollectionCell: UICollectionViewCell {
//    @IBOutlet weak var thumbnailView: UIImageView!
//    @IBOutlet weak var itemTitle: UILabel!
//    
//    var item:AGSPortalItem? {
//        didSet {
//            self.thumbnailView.image = #imageLiteral(resourceName: "Loading Thumbnail")
//            item?.thumbnail?.load() { error in
//                if let error = error {
//                    print("Couldn't get thumb for Basemap Cell: \(error.localizedDescription)")
//                }
//                self.thumbnailView.image = self.item!.thumbnail?.image ?? #imageLiteral(resourceName: "Default Thumbnail")
//            }
//            
//            itemTitle.text = item?.title ?? "Unknown Basemap"
//        }
//    }
//}

