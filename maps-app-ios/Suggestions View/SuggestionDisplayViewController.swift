//
//  SuggestionDisplayViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/14/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

class SuggestionDisplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIContainerView {
    
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
    
    var containerView: UIView? {
        return view.superview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        suggestions = nil
        
        MapsAppNotifications.observeSearchNotifications(searchResultHandler: { _ in
            self.suggestions = nil
        }, suggestionsAvailableHandler: { suggestions in
            self.suggestions = suggestions
        })        
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
            mapsAppAGSServices.search(suggestion: suggestion)
            suggestions = nil
        }
    }
}
