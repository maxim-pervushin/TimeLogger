//
//  TableLayout.swift
//  HyperTimeLogger
//
//  Created by Maxim Pervushin on 19/10/15.
//  Copyright © 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class TableLayout: UICollectionViewLayout {
    
    var numberOfColumns: Int = 3
    
    var rowHeight = CGFloat(50)
    
    private var numberOfSections: Int {
        get {
            guard let collectionView = collectionView, result = collectionView.dataSource?.numberOfSectionsInCollectionView?(collectionView) else {
                return 0
            }
            return result
        }
    }
    
    private func numberOfItemsInSection(section: Int) -> Int {
        guard let collectionView = collectionView, result = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section) else {
            return 0
        }
        return result
    }
    
    private func numberOfRowsInSection(section: Int) -> Int {
        let numberOfItems = numberOfItemsInSection(section)
        return (numberOfItems / numberOfColumns) + (CGFloat(numberOfItems % numberOfColumns) > 0 ? 1 : 0)
    }
    
    private func sizeForSection(section: Int) -> CGSize {
        guard let collectionView = collectionView else {
            return CGSizeZero
        }
        
        return CGSizeMake(collectionView.frame.size.width, CGFloat(numberOfRowsInSection(section)) * rowHeight)
    }
    
    private func frameForSection(section: Int) -> CGRect {
        var horizontalOffset: CGFloat = 0;
        var verticalOffset: CGFloat = 0;
        
        for var previousSection = 0; previousSection < section; previousSection++ {
            let previousSectionSize = sizeForSection(previousSection)
            verticalOffset += previousSectionSize.height
        }
        
        let size = sizeForSection(section)
        return CGRectMake(horizontalOffset, verticalOffset, size.width, size.height)
    }
    
    private func columnForIndexPath(indexPath: NSIndexPath) -> Int {
        return indexPath.row % numberOfColumns
    }
    
    private func lineForIndexPath(indexPath: NSIndexPath) -> Int {
        return (indexPath.row - columnForIndexPath(indexPath)) / numberOfColumns
    }
    
    private func horizontalOffsetForItemAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        return CGFloat(columnForIndexPath(indexPath)) * collectionView.bounds.size.width / CGFloat(numberOfColumns)
    }
    
    private func verticalOffsetForItemAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        var verticalSectionOffset: CGFloat = 0;
        for var section = 0; section < indexPath.section; section++ {
            verticalSectionOffset += sizeForSection(section).height
        }
        
        verticalSectionOffset += CGFloat(lineForIndexPath(indexPath)) * rowHeight
        
        return verticalSectionOffset
    }
    
    private func frameForItemAtIndexPath(itemIndexPath: NSIndexPath) -> CGRect {
        guard let collectionView = collectionView else {
            return CGRectZero
        }
        
        return CGRectMake(horizontalOffsetForItemAtIndexPath(itemIndexPath), verticalOffsetForItemAtIndexPath(itemIndexPath), collectionView.bounds.size.width / CGFloat(numberOfColumns), rowHeight)
    }
    
    override func collectionViewContentSize() -> CGSize {
        let lastSectionFrame = frameForSection(numberOfSections - 1)
        return CGSizeMake(lastSectionFrame.origin.x + lastSectionFrame.size.width, lastSectionFrame.origin.y + lastSectionFrame.size.height)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = Array<UICollectionViewLayoutAttributes>()
        
        for var section = 0; section < numberOfSections; section++ {
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
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: itemIndexPath)
        attributes.frame = frameForItemAtIndexPath(itemIndexPath)
        return attributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
