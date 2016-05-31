//
// Created by Maxim Pervushin on 31/05/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class HTLTableView: UITableView {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView?.frame = bounds
    }

    private func commonInit() {
        backgroundColor = UIColor.clearColor()
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "Background")
        backgroundView = backgroundImageView
    }
}
