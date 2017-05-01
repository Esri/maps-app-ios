//
//  SearchViewController.swift
//  VCTesting
//
//  Created by Nicholas Furness on 3/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

class SearchViewController : UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var suggestDebouncer:Debouncer = {
        let debouncer = Debouncer(delay: 0.1) {
            MapsAppNotifications.postSuggestNotification(searchBar: self.searchBar)
        }
        return debouncer
    }()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        MapsAppNotifications.postSearchNotification(searchBar: searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        suggestDebouncer.call()
    }
}
