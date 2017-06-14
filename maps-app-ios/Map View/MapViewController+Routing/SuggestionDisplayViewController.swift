//
//  SuggestionDisplayViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/14/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

class SuggestionDisplayViewController: UITableViewController {
    
    var suggestions:[AGSSuggestResult]? {
        didSet {
            defer {
                self.tableView.reloadData()

                let size = self.tableView.contentSize
                let frame = self.tableView.frame
                let newFrame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: size.height))
                self.tableView.frame = newFrame
            }
            
            guard let newSuggestions = suggestions, newSuggestions.count > 0 else {
                self.view.isHidden = true
                return
            }
            
            self.view.isHidden = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.view.translatesAutoresizingMaskIntoConstraints = false
        
        suggestions = nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeocodeSuggestionCell", for: indexPath)
        
        if let suggestion = suggestions?[indexPath.row] {
            cell.textLabel?.text = suggestion.label
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let suggestion = suggestions?[indexPath.row] {
            print("Go geocode >>\(suggestion.label)<<!")
            
            MapsAppNotifications.postSearchFromSuggestionNotification(suggestion: suggestion)
            
            suggestions = nil
        }
    }
}
