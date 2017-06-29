//
//  UICollectionView+CellAtCenter.swift
//  maps-app-ios
//
//  Created by Nicholas Furness on 6/28/17.
//  Copyright © 2017 Esri. All rights reserved.
//

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
