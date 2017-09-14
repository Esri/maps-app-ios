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

extension UICollectionView {
    var cellAtVisibleCenter:UICollectionViewCell? {
        // Find the coordinate of the collection view content area currently at 
        // the center of the scrollable visible area.
        let center = CGPoint(x: self.contentOffset.x + (self.frame.size.width / 2),
                             y: self.contentOffset.y + (self.frame.size.height / 2))
        if let index = self.indexPathForItem(at: center) {
            return self.cellForItem(at: index)
        }
        return nil
    }
}
