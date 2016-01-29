//
//  HTLBackgroundView.swift
//  HyperTimeLogger
//
//  Created by Maxim Pervushin on 28/01/16.
//  Copyright © 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

@IBDesignable class HTLBackgroundView: UIView {

    static let backgroundImage = UIImage(named: "Background")

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let image = HTLBackgroundView.backgroundImage {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            // TODO: Find better solution. Image should be stretched if device screen is bigger than image.
            let drawRect = CGRectMake(-imageWidth / 2, -imageHeight / 2, imageWidth / 1, imageHeight / 1)
            image.drawInRect(drawRect, blendMode: .Normal, alpha: 0.25)
        }
    }
}
