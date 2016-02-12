//
// Created by Maxim Pervushin on 28/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

@objc public protocol HTLLineLayoutDelegate {
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: HTLLineLayout,
                        widthForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
}

public class HTLLineLayout: UICollectionViewLayout {

    private let _defaultNumberOfSections = 1
    private let _defaultRowWidth = CGFloat(100)
    private let _maxNumberOfRows: Int = 1

    public weak var delegate: HTLLineLayoutDelegate? {
        didSet {
            invalidateLayout()
        }
    }

    private func numberOfSections() -> Int {
        guard let collectionView = collectionView else {
            return 0
        }
        if let result = collectionView.dataSource?.numberOfSectionsInCollectionView?(collectionView) {
            return result
        }
        return _defaultNumberOfSections
    }

    private func numberOfItemsInSection(section: Int) -> Int {
        guard let collectionView = collectionView else {
            return 0
        }
        if let result = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section) {
            return result
        }
        return 0
    }

    private func widthForItemAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        if let width = delegate?.collectionView(collectionView, layout: self, widthForItemAtIndexPath: indexPath) {
            return width
        }
        return _defaultRowWidth;
    }

    private func sizeForSection(section: Int) -> CGSize {
        guard let collectionView = collectionView else {
            return CGSizeZero
        }

        var width = CGFloat(0)
        let numberOfItems = numberOfItemsInSection(section)
        if numberOfItems > 0 {
            for row in 0 ... numberOfItems - 1 {
                width += widthForItemAtIndexPath(NSIndexPath(forRow: row, inSection: section))
            }
        }

        return CGSizeMake(width, collectionView.frame.size.height)
    }

    private func frameForSection(section: Int) -> CGRect {
        var horizontalOffset: CGFloat = 0;
        let verticalOffset: CGFloat = 0;

        for var previousSection: Int = 0; previousSection < section; previousSection++ {
            horizontalOffset += sizeForSection(previousSection).width
        }

        let size = sizeForSection(section)
        return CGRectMake(horizontalOffset, verticalOffset, size.width, size.height)
    }

    private func rowForIndexPath(indexPath: NSIndexPath) -> Int {
        return indexPath.row % _maxNumberOfRows
    }

    private func lineForIndexPath(indexPath: NSIndexPath) -> Int {
        return (indexPath.row - rowForIndexPath(indexPath)) / _maxNumberOfRows
    }

    private func verticalOffsetForItemAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }

        return CGFloat(rowForIndexPath(indexPath)) * collectionView.bounds.size.width / CGFloat(_maxNumberOfRows)
    }

    private func horizontalOffsetForItemAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        var horizontalOffset: CGFloat = 0;

        for var section: Int = 0; section < indexPath.section; section++ {
            horizontalOffset += sizeForSection(section).width
        }

        for var row: Int = 0; row < lineForIndexPath(indexPath); row++ {
            horizontalOffset += widthForItemAtIndexPath(NSIndexPath(forRow: row, inSection: indexPath.section))
        }

        return horizontalOffset
    }

    private func frameForItemAtIndexPath(itemIndexPath: NSIndexPath) -> CGRect {
        guard let collectionView = collectionView else {
            return CGRectZero
        }

        return CGRectMake(horizontalOffsetForItemAtIndexPath(itemIndexPath),
                verticalOffsetForItemAtIndexPath(itemIndexPath),
                widthForItemAtIndexPath(itemIndexPath),
                collectionView.bounds.size.height)
    }

    override public func collectionViewContentSize() -> CGSize {
        let lastSectionFrame = frameForSection(numberOfSections() - 1)
        return CGSizeMake(lastSectionFrame.origin.x + lastSectionFrame.size.width,
                lastSectionFrame.origin.y + lastSectionFrame.size.height)
    }

    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = Array<UICollectionViewLayoutAttributes>()

        for var section = 0; section < numberOfSections(); section++ {
            if !CGRectIntersectsRect(frameForSection(section), rect) {
                continue
            }

            for var item = 0; item < numberOfItemsInSection(section); item++ {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let frame = frameForItemAtIndexPath(indexPath)
                if !CGRectIntersectsRect(frame, rect) {
                    continue
                }
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = frame
                attributesArray.append(attributes)
            }
        }

        return attributesArray
    }

    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = frameForItemAtIndexPath(indexPath)
        return attributes
    }

    override public func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: itemIndexPath)
        attributes.frame = frameForItemAtIndexPath(itemIndexPath)
        return attributes
    }

    override public func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
