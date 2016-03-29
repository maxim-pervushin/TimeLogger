//
//  HTLLineView.swift
//  HyperTimeLogger
//
//  Created by Maxim Pervushin on 28/01/16.
//  Copyright © 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

public class HTLLineView: UIView {

    private var thickness: CGFloat {
        return 1.0 / UIScreen.mainScreen().scale
    }
    
    private var _frame: CGRect
    
    override public var frame: CGRect {
        set {
            setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
            setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
            _frame = CGRect(x: newValue.origin.x, y: newValue.origin.y, width: newValue.size.width, height: thickness)
            super.frame = _frame
        }
        get {
            return _frame
        }
    }
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(size.width, thickness)
    }
    
    override public func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, thickness)
    }
    
    override init(frame: CGRect) {
        _frame = CGRectZero
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        _frame = CGRectZero
        super.init(coder: aDecoder)
    }
}
