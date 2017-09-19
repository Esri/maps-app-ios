// Copyright 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

extension FeedbackViewController {
    var mode:FeedbackMode {
        get {
            return mapViewController?.mode ?? .none
        }
        set {
            self.mapViewController?.mode = newValue
        }
    }
    
    func setupModeChangeListener() {
        MapsAppNotifications.observeModeChangeNotification(owner: self) { oldValue, newValue in
            self.setUIForMode(mode: newValue, previousMode: oldValue)
        }
    }
    
    func setUIForMode(mode:FeedbackMode, previousMode:FeedbackMode) {
        guard mode != .none else {
            return
        }
        
        if !(mode ~== previousMode) {
            self.performSegue(withIdentifier: "\(mode.segueName)", sender: nil)
        }
        
        switch mode {
        case .geocodeResult(let result):
            self.geocodeResultViewController?.result = result
        case .routeResult(let result):
            self.routeResultViewController?.routeResult = result
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segue = segue as? FeedbackContentsSegue {
            segue.feedbackViewController = self
        }
    }
}
