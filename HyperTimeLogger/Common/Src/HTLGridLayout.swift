//
// Created by Maxim Pervushin on 16/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit


class HTLGridLayout: ZLBalancedFlowLayout {

    private let _columnsCount = CGFloat(3)
    private let _rowHeight = CGFloat(50)

    override var itemSize: CGSize {
        set {
        }
        get {
            if let collectionView = collectionView {
                return CGSizeMake(collectionView.bounds.size.width / _columnsCount, _rowHeight)
            }
            return CGSizeZero
        }
    }

    override var rowHeight: CGFloat {
        set {
        }
        get {
            return _rowHeight
        }
    }

    override var enforcesRowHeight: Bool {
        set {
        }
        get {
            return true
        }
    }

    override var minimumLineSpacing: CGFloat {
        set {
        }
        get {
            return 0
        }
    }

    override var minimumInteritemSpacing: CGFloat {
        set {
        }
        get {
            return 0
        }
    }
}
