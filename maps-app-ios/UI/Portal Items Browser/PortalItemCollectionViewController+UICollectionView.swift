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

extension PortalItemCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PortalItemCollectionCell,
            let portalItem = cell.item else {
                return
        }
        
        portalItemDelegate?.portalItemSelected(item: portalItem)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortalItem", for: indexPath)
        
        if let cell = cell as? PortalItemCollectionCell, indexPath.row <= items.count {
            cell.item = items[indexPath.row]
        }
        
        return cell
    }
}

extension PortalItemCollectionViewController: UICollectionViewDataSourcePrefetching {
    // Remember to write up the prefetchDelegtate in the Storyboard
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let item = items[indexPath.row]
            item.thumbnail?.load() { error in
                if let error = error {
                    print("Error pre-fetching portal item at index \(indexPath.row): \(error.localizedDescription)")
                }
            }
        }
    }
}

