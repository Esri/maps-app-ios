//
//  SuggestionDisplayViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/14/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

class SuggestionDisplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var suggestions:[AGSSuggestResult]? {
        didSet {
            defer {
                self.tableView.reloadData()
                heightContraint.constant = self.tableView.contentSize.height
            }
            
            if let newSuggestions = suggestions, newSuggestions.count > 0 {
                self.view.isHidden = false
            } else {
                self.view.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.SearchCompleted, object: nil, queue: nil) { notification in
            self.suggestions = nil
        }
        
        suggestions = nil
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
            MapsAppNotifications.postSearchFromSuggestionNotification(suggestion: suggestion)
            suggestions = nil
        }
    }
}
