//
//  FeedbackViewController+RelatedViewControllers.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 7/15/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import Foundation

extension FeedbackViewController {
    var mapViewController:MapViewController? {
        return self.parent as? MapViewController
    }
    
    var geocodeResultViewController:GeocodeResultViewController? {
        return self.childViewControllers.filter({ $0 is GeocodeResultViewController }).first as? GeocodeResultViewController
    }
    
    var routeResultViewController:RouteResultViewController? {
        return self.childViewControllers.filter({ $0 is RouteResultViewController }).first as? RouteResultViewController
    }    
}
