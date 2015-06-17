//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLPieChartCell.h"
#import "XYPieChart.h"


static const CGFloat kBorderWidth = 8;


@implementation HTLPieChartCell

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat radius = self.bounds.size.width / 2;
    self.pieChart.pieCenter = CGPointMake(radius, radius);
    self.pieChart.pieRadius = radius - kBorderWidth;
    [self.pieChart reloadData];
}

@end