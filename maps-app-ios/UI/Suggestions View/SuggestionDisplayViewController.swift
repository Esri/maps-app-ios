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

class SuggestionDisplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var suggestions:[AGSSuggestResult]? {
        didSet {
            self.tableView.reloadData()
            heightContraint.constant = self.tableView.contentSize.height

            setViewHiddenState()
        }
    }
    
    private func setViewHiddenState() {
        if let newSuggestions = suggestions, newSuggestions.count > 0 {
            containerView?.isHidden = false
        } else {
            containerView?.isHidden = !(isValidToShow && (suggestions?.count ?? 0) > 0)
        }
    }
    
    var isValidToShow:Bool = true {
        didSet {
            if !isValidToShow {
                self.view.isHidden = false
            }
        }
    }
    
    private var containerView: UIView? {
        return view.superview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        suggestions = nil
        
        MapsAppNotifications.observeSearchNotifications(owner: self, searchResultHandler: { _ in
            self.suggestions = nil
        }, suggestionsAvailableHandler: { suggestions in
            self.suggestions = suggestions
        })        
    }
    
    deinit {
        MapsAppNotifications.deregisterNotificationBlocks(forOwner: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setViewHiddenState()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeocodeSuggestionCell", for: indexPath)
        
        if let suggestion = suggestions?[indexPath.row] {
            cell.textLabel?.text = suggestion.label
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let suggestion = suggestions?[indexPath.row] {
            arcGISServices.search(suggestion: suggestion)
            suggestions = nil
        }
    }
}
