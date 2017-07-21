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
            defer {
                self.debouncerCanceled = false
            }
            
            guard !self.debouncerCanceled else {
                return
            }
            
            guard let searchText = self.searchBar.text else {
                return
            }
            
            arcGISServices.getSuggestions(forSearchText: searchText)
        }
        
        return debouncer
    }()
    
    var debouncerCanceled:Bool = false {
        didSet {
            if debouncerCanceled {
                suggestDebouncer.cancel()
            }
        }
    }
    
    // MARK: UI Appearance
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    // MARK: Suggestions UI masking
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        mapsAppContext.validToShowSuggestions = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        mapsAppContext.validToShowSuggestions = false
        MapsAppNotifications.postSearchCompletedNotification()
    }
    
    // MARK: Suggestions UI trigger
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        suggestDebouncer.call()
    }
    
    // MARK: Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        debouncerCanceled = true

        if let searchText = searchBar.text {
            arcGISServices.search(searchText: searchText)
        }
    }
    
    // MARK: Cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        debouncerCanceled = true

        searchBar.resignFirstResponder()
        searchBar.text = nil
        MapsAppNotifications.postSearchCompletedNotification()
    }
}
