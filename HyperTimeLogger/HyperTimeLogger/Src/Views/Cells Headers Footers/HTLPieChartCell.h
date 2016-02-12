//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XYPieChart;


@interface HTLPieChartCell : UITableViewCell

@property(nonatomic, weak) IBOutlet XYPieChart *pieChart;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@end