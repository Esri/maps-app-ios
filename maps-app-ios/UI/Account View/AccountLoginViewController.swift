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

import UIKit

fileprivate let signUpURL = URL(string: "https://developers.arcgis.com/sign-up")!

class AccountLoginViewController: UIViewController {
    @IBAction func signIn(_ sender: Any) {
        let portalURL = mapsAppContext.currentPortal?.url
        mapsAppContext.signIn(portalURL: portalURL)
    }
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(signUpURL, options: [:], completionHandler: nil)
    }
}
