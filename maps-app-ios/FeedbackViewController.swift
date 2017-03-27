//
//  FeedbackViewController.swift
//  VCTesting
//
//  Created by Nicholas Furness on 3/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import UIKit
import ArcGIS

typealias FeedbackMode = MapsAppMode

class FeedbackViewController : UIViewController {

    @IBOutlet weak var containerView: UIVisualEffectView!
    
    var mapViewController:MapViewController? {
        return self.parent as? MapViewController
    }

    var mode:FeedbackMode {
        get {
            return mapViewController?.mode ?? .none
        }
        set {
            self.mapViewController?.mode = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupModeChangeListener()
    }
    
    func setupModeChangeListener() {
        NotificationCenter.default.addObserver(forName: Notification.Name("ModeChanged"), object: nil, queue: nil) { (notification) in
            if let newValue = notification.userInfo?[NSKeyValueChangeKey.newKey] as? FeedbackMode, let oldValue = notification.userInfo?[NSKeyValueChangeKey.oldKey] as? FeedbackMode {
                guard newValue != .none else {
                    return
                }
                
                if !(newValue ~== oldValue) {
                    self.performSegue(withIdentifier: "\(self.mode)Segue", sender: nil)
                }
                
                switch newValue {
                case .geocodeResult(let result):
                    self.geocodeResultViewController?.result = result
                case .routeResult(let result):
                    self.routeResultViewController?.routeResult = result
                default:
                    break
                }
            }
        }
    }

    @IBAction func returnToSearch(_ segue:UIStoryboardSegue) {
        self.mode = .search
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let from = self.childViewControllers.first
        self.swapChildVCs(from: from, to: segue.destination)
    }
    
    func swapChildVCs(from:UIViewController?, to:UIViewController) {
        
        if to is RouteResultViewController {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80)
        } else {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        }
        
        // Code stolen from https://github.com/mluton/EmbeddedSwapping and modified for Swift 3
        to.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        
        guard let from = from else {
            // First time we're setting something. Just set it, don't transition to it.
            self.addChildViewController(to)
            self.containerView.addSubview(to.view)
            to.didMove(toParentViewController: self)
            return
        }
        
        // Moving from one thing to another
        from.willMove(toParentViewController: nil)
        self.addChildViewController(to)
        self.transition(from: from, to: to, duration: 0.3, options: .transitionCrossDissolve, animations: nil) { (finished) in
            from.removeFromParentViewController()
            to.didMove(toParentViewController: self)
        }
    }
}
