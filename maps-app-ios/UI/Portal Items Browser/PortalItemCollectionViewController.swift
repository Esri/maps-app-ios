//
//  PortalItemCollectionViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 5/1/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

class PortalItemCollectionViewController: UICollectionViewController {
    @IBOutlet var portalItemDelegate:PortalItemCollectionViewDelegate?
    
    var items:[AGSPortalItem] = [] {
        didSet {
            collectionView?.reloadData()
            collectionView?.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = portalItemDelegate?.items ?? []
    }
}
