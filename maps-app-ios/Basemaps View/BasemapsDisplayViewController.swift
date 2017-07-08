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

class BasemapsDisplayViewController: UIViewController {
    var items:[AGSPortalItem] {
        get {
            return mapsAppState.basemaps
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // This will get called during the Unwind Segue that each PortalItemCollectionCell triggers.
        super.prepare(for: segue, sender: sender)
        
        // Tell the mapsApp that we've picked a web map to open.
        mapsAppState.currentItem = (sender as? PortalItemCollectionCell)?.item
    }
    
    @IBAction func cancelBasemapPicker(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
