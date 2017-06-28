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
            maneuversView.reloadData();
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.superview?.isHidden = (self.directions == nil)
            })

            tidyUpCellLayout()
        }
    }
    
    var currentManeuver:AGSDirectionManeuver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        directions = nil

        maneuversView.decelerationRate = UIScrollViewDecelerationRateFast
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tidyUpCellLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tidyUpCellLayout()
    }
    
    private func tidyUpCellLayout() {
        if let layout = maneuversView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: maneuversView.frame.size.width - layout.minimumInteritemSpacing, height: maneuversView.frame.size.height)
            if let visibleIndexPath = maneuversView.indexPathsForVisibleItems.first {
                maneuversView.scrollToItem(at: visibleIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return directions?.directionManeuvers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "maneuverCell", for: indexPath)
        
        if let cell = cell as? DirectionManeuverCell, let maneuvers = directions?.directionManeuvers, indexPath.row < maneuvers.count {
            let maneuver = maneuvers[indexPath.row]
            cell.index = indexPath.row
            cell.maneuver = maneuver
        }
        
        return cell
    }
    
    var nextCell:UICollectionViewCell?
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        nextCell = cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let maneuverCell = nextCell as? DirectionManeuverCell, maneuverCell != cell, let maneuver = maneuverCell.maneuver {
            MapsAppNotifications.postManeuverFocusNotification(maneuver: maneuver)
        }

    }
}
