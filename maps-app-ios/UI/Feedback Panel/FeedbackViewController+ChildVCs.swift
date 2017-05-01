//
//  FeedbackViewController+ChildVCs.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 4/1/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit

extension FeedbackViewController {
    var searchViewController:SearchViewController? {
        get {
            return self.childViewControllers.filter({ $0 is SearchViewController }).first as? SearchViewController
        }
    }
    
    var geocodeResultViewController:GeocodeResultViewController? {
        get {
            return self.childViewControllers.filter({ $0 is GeocodeResultViewController }).first as? GeocodeResultViewController
        }
    }
    
    var routeResultViewController:RouteResultViewController? {
        get {
            return self.childViewControllers.filter({ $0 is RouteResultViewController }).first as? RouteResultViewController
        }
    }
}
