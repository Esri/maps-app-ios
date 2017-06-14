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
        MapsAppNotifications.postSearchCompletedNotification()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        suggestDebouncer.call()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        MapsAppNotifications.postSearchCompletedNotification()
    }
}
