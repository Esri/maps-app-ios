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
            if directions == nil {
                currentCellIndex = nil
            }
            
            maneuversView.reloadData();
            
            configureCollectionViewLayout()

            UIView.animate(withDuration: 0.25, animations: {
                self.view.superview?.isHidden = (self.directions == nil)
            })
            
            setCurrentCell()
        }
    }
    
    var currentCellIndex:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maneuversView.decelerationRate = UIScrollViewDecelerationRateNormal
        
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
        
        directions = nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setCurrentCell()
    }
    
    @IBAction func maneuverDescriptionTapped(_ sender: Any) {
        print("Maneuver Gesture Tapped")
        if let currentIndex = currentCellIndex, let cell = maneuversView.cellForItem(at: currentIndex) as? DirectionManeuverCell, let maneuver = cell.maneuver, let targetExtent = maneuver.geometry?.extent {
            let newExtent = targetExtent.toBuilder().expand(byFactor: 1.2).toGeometry()
            MapsAppNotifications.postMapViewRequestFocusOnExtentNotification(extent: newExtent)
        }
    }
    
    func setCurrentCell() {
        guard directions != nil else {
            currentCellIndex = nil
            return
        }
        
        if let cell = maneuversView.cellAtVisibleCenter as? DirectionManeuverCell,
            let cellIndex = maneuversView.indexPath(for: cell),
            currentCellIndex != cellIndex,
            let maneuver = cell.maneuver {
            currentCellIndex = cellIndex
            MapsAppNotifications.postManeuverFocusNotification(maneuver: maneuver)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Handle the view orientation changing (or any resize for that matter)
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { context in
            guard !context.isCancelled else {
                return
            }
            
            guard !self.maneuversView.isHidden else {
                return
            }

            // Figure out what the cell size should be for the new size
            self.configureCollectionViewLayout()
            
            // If we have a current cell, make sure it's displayed.
            if let cellIndex = self.currentCellIndex {
                self.maneuversView.scrollToItem(at: cellIndex, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            }
        }
    }
    
    private func configureCollectionViewLayout() {
        if let layout = maneuversView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: maneuversView.frame.size.width - layout.minimumInteritemSpacing, height: maneuversView.frame.size.height)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DirectionManeuverCell, let maneuver = cell.maneuver {
            MapsAppNotifications.postManeuverFocusNotification(maneuver: maneuver)
        }
    }
}
