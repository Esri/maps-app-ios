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

extension AccountDetailsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Add this function to any ViewController embedding a PortalItemCollectionViewController in
        // the prepareForSegue() method.
        if let portalItemsCollectionVC = segue.destination as? PortalItemCollectionViewController {
            portalItemsCollectionVC.portalItemDelegate = self
            
            // We'll keep a handle to this to update the content when the current folder changes.
            contentVC = portalItemsCollectionVC
        }
    }
}

extension AccountDetailsViewController: PortalItemCollectionViewDelegate {
    var items: [AGSPortalItem]? {
        return mapsAppContext.currentFolder?.webMaps
    }
    
    func portalItemSelected(item: AGSPortalItem) {
        mapsAppContext.currentItem = item
    }
}

