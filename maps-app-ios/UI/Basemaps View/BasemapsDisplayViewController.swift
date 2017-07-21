//
//  BasemapsDisplayViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/19/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

class BasemapsDisplayViewController: UIViewController {
    @IBAction func cancelBasemapPicker(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Add this function to any ViewController embedding a PortalItemCollectionViewController in
        // the prepareForSegue() method.
        if let portalItemsCollectionVC = segue.destination as? PortalItemCollectionViewController {
            portalItemsCollectionVC.portalItemDelegate = self
        }
    }
}

extension BasemapsDisplayViewController: PortalItemCollectionViewDelegate {
    var items:[AGSPortalItem]? {
        get {
            return mapsAppContext.basemaps
        }
    }
    
    func portalItemSelected(item: AGSPortalItem) {
        mapsAppContext.currentBasemap = item
        dismiss(animated: true, completion: nil)
    }
}
