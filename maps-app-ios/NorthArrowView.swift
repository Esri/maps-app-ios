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

fileprivate let rotationKeyPath = #keyPath(AGSMapView.rotation)

public class NorthArrowView: RoundedImageView {

    private var kvoContext = 0
    
    @IBOutlet weak var mapView: AGSMapView? {
        willSet {
            mapView?.removeObserver(self, forKeyPath: rotationKeyPath)
        }
        didSet {
            // Add NorthArrowController as an observer of the mapView's rotation.
            mapView?.addObserver(self, forKeyPath: rotationKeyPath, options: [.new], context: &kvoContext)

            setVisibilityFromMapView()
        }
    }

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
    private var initialAlpha:CGFloat?
    
    func resetNorth() {
        self.mapView?.setViewpointRotation(0, completion: nil)
    }
    
    func setVisibilityFromMapView(animate:Bool = false) {
        guard autoHide else {
            self.isHidden = false
            return
        }
        
        if !isHidden && initialAlpha == nil {
            // Remember this for when we re-show. Could be non-zero from the Storyboard.
            initialAlpha = alpha
        }
        
        guard let maxAlpha = initialAlpha, maxAlpha > 0 else {
            // No point animating if maxAlpha is fully transparent
            return
        }
        
        let duration = animate ? 0.25 : 0
        
        if self.mapView?.rotation != 0 {
            guard self.isHidden else {
                // Already visible. No need to animate
                return
            }
            
            // Show if there's a MapView and rotation <> 0
            DispatchQueue.main.async {
                self.isHidden = false
                print("Animating in")
                UIView.animate(withDuration: duration, animations: {
                    self.alpha = maxAlpha
                })
            }
        } else {
            guard self.alpha > 0 else {
                // Already hidden. No need to animate
                return
            }
            
            DispatchQueue.main.async {
                print("Animating out")
                UIView.animate(withDuration: duration, animations: {
                    self.alpha = 0
                }, completion: { _ in
                    self.isHidden = true
                })
            }
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == rotationKeyPath, context == &kvoContext {
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
