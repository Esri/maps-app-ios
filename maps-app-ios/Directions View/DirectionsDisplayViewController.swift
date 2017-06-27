//
//  DirectionsDisplayViewController.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/26/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

class DirectionsDisplayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var maneuversView: UICollectionView!
    
    var directions:AGSRoute? {
        didSet {
            self.maneuversView.reloadData();
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.superview?.isHidden = (self.directions == nil)
            })
        }
    }
    
    var currentManeuver:AGSDirectionManeuver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        directions = nil

        self.view.translatesAutoresizingMaskIntoConstraints = false

        NotificationCenter.default.addObserver(forName: MapsAppNotifications.Names.MapViewModeChanged, object: nil, queue: OperationQueue.main) { notification in
            if let newMode = notification.newMapViewMode {
                switch newMode {
                case .routeResult(let route):
                    self.directions = route
                default:
                    self.directions = nil
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return directions?.directionManeuvers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "maneuverCell", for: indexPath)
        
        if let cell = cell as? DirectionsManeuverCell, let maneuvers = directions?.directionManeuvers, indexPath.row < maneuvers.count {
            cell.maneuver = maneuvers[indexPath.row]
        }
        
        return cell
    }
}
