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

class PortalItemCollectionCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    
    var item:AGSPortalItem? {
        didSet {
            layer.cornerRadius = 4
            
            self.thumbnailView.image = #imageLiteral(resourceName: "Loading Thumbnail")
            item?.thumbnail?.load() { error in
                if let error = error {
                    print("Couldn't get thumb for Portal Item Cell: \(error.localizedDescription)")
                }
                self.thumbnailView.image = self.item!.thumbnail?.image ?? #imageLiteral(resourceName: "Default Thumbnail")
            }
            
            itemTitle.text = item?.title ?? "Unknown Item"
        }
    }
}

