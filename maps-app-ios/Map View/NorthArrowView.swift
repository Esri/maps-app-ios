// Copyright 2016 Esri.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import ArcGIS

public class NorthArrowView: RoundedImageView {

    @IBOutlet weak var mapView: AGSMapView? {
        didSet {
            if let mapView = mapView {
                // Add NorthArrowController as an observer of the mapView's rotation.
                mapView.addObserver(self, forKeyPath: #keyPath(AGSMapView.rotation), options: [.new], context: &kvoContext)
            } else {
                mapView?.removeObserver(self, forKeyPath: #keyPath(AGSMapView.rotation))
            }
            setVisibilityFromMapView()
        }
    }

    private var kvoContext = 0
    
    lazy var tapGesture:UITapGestureRecognizer = {
        let r = UITapGestureRecognizer(target: self, action: #selector(resetNorth))
        return r
    }()
    
    @IBInspectable
    var autoHide:Bool = true
    
    @IBInspectable
    var tapForNorth:Bool = true {
        didSet {
            self.isUserInteractionEnabled = tapForNorth
            
            if self.isUserInteractionEnabled {
                self.addGestureRecognizer(tapGesture)
            } else {
                self.removeGestureRecognizer(tapGesture)
            }
        }
    }
    
    // Track any alpha override that may have been set in the Storyboard.
    private var maxAlpha:CGFloat = -1
    
    func resetNorth() {
        self.mapView?.setViewpointRotation(0, completion: nil)
    }
    
    func setVisibilityFromMapView(animate:Bool = false) {
        guard autoHide else {
            self.isHidden = false
            return
        }
        
        if !isHidden && maxAlpha < 0 {
            // Remember this for when we re-show. Could be non-zero from the Storyboard.
            maxAlpha = alpha
        }
        
        let duration = animate ? 0.25 : 0
        
        if self.mapView?.rotation != 0 {
            // Show if there's a MapView and rotation <> 0
            self.isHidden = false
            UIView.animate(withDuration: duration, animations: {
                self.alpha = self.maxAlpha
            })
        } else {
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.isHidden = true
            })
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == #keyPath(AGSMapView.rotation)) && (context == &kvoContext) {
            // Rotate north arrow to match the map view rotation.
            let mapRotation = self.degreesToRadians(degrees: (360 - (self.mapView?.rotation ?? 0)))
            let transform = CGAffineTransform(rotationAngle: mapRotation)
            self.transform = transform

            setVisibilityFromMapView(animate: true)
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func degreesToRadians(degrees : Double) -> CGFloat {
        return CGFloat(degrees * Double.pi / 180)
    }
}
