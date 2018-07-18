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

import ArcGIS

fileprivate enum AppPreferenceKey: String {
    case viewpoint
    case portalURL
}

class AppPreferences: AGSAppPreferences {
    static var viewpoint:AGSViewpoint? {
        get {
            return getAGS(type: AGSViewpoint.self, forKey: AppPreferenceKey.viewpoint)
        }
        set {
            setAGS(agsObject: newValue, withKey: AppPreferenceKey.viewpoint)
        }
    }
    
    static var portalURL:URL? {
        get {
            return getURL(forKey: AppPreferenceKey.portalURL)
        }
        set {
            set(value: newValue, forKey: AppPreferenceKey.portalURL)
        }
    }
}
