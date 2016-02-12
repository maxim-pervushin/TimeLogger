//
// Created by Maxim Pervushin on 28/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit
import QuartzCore

//@IBDesignable public class HTLAddButtonWidget: UIVisualEffectView {
@IBDesignable public class HTLAddButtonWidget: UIView {

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(frame.width, frame.height) / 2
        for view in subviews {
            view.layer.cornerRadius = min(frame.width, frame.height) / 2
        }
    }

}

@IBDesignable public class HTLRoundedImageView: UIImageView {

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(frame.width, frame.height) / 2
    }
}