// Copyright 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import ArcGIS

class SearchViewController : UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard #available(iOS 11, *) else {
            searchBar.constraints.filter({ $0.identifier == "ios11SearchbarHeight" }).first?.isActive = false
            return
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
