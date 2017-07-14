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
    var debouncerCanceled:Bool = false {
        didSet {
            if debouncerCanceled {
                suggestDebouncer.cancel()
            }
        }
    }
    
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
            
            mapsAppAGSServices.getSuggestions(forSearchText: searchText)
        }
        
        return debouncer
    }()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        debouncerCanceled = true
        mapsAppContext.validToShowSuggestions = false

        if let searchText = searchBar.text {
            mapsAppAGSServices.search(searchText: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        mapsAppContext.validToShowSuggestions = true
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        mapsAppContext.validToShowSuggestions = false
        MapsAppNotifications.postSearchCompletedNotification()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        debouncerCanceled = true
        mapsAppContext.validToShowSuggestions = false

        searchBar.resignFirstResponder()
        searchBar.text = nil
        MapsAppNotifications.postSearchCompletedNotification()
    }
}
