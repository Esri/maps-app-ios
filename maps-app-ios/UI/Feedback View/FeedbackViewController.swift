//
//  FeedbackViewController.swift
//  VCTesting
//
//  Created by Nicholas Furness on 3/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

import ArcGIS

class FeedbackViewController : UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false

        setupModeChangeListener()
    }
    
    @IBAction func returnToSearch(_ segue:UIStoryboardSegue) {
        self.mode = .search
    }
}
