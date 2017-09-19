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

extension MapViewController {
    func setupBasemapChangeHandler() {
        MapsAppNotifications.observeBasemapChangedNotification(owner: self) { newBasemap in
            self.mapView.map?.basemap = newBasemap
            
            newBasemap.load(){ error in
                guard error == nil else {
                    print("Error loading basemap: \(error!.localizedDescription)")
                    return
                }
                
                if let firstLayer = newBasemap.baseLayers.firstObject as? AGSLayer {
                    firstLayer.load() { error in
                        guard error == nil else {
                            print("Error loading basemap layer: \(error!.localizedDescription)")
                            return
                        }
                        
                        self.mapView.map?.maxScale = firstLayer.maxScale
                        print("Set map maxScale to \(firstLayer.maxScale)")
                    }
                }
            }
        }
    }
}
