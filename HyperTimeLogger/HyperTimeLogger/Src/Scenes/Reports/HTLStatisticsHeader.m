//
// Created by Maxim Pervushin on 07/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStatisticsHeader.h"
#import "XYPieChart.h"
#import "HTLStatisticsItem.h"
#import "HTLMark.h"


@interface HTLStatisticsHeader () <XYPieChartDataSource, XYPieChartDelegate> {
    NSArray *_statistics;
}

@property(nonatomic, weak) IBOutlet XYPieChart *chart;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation HTLStatisticsHeader
@dynamic statistics;

- (NSArray *)statistics {
    return _statistics;
}

- (void)initUI {
    self.chart.showLabel = NO;
    self.chart.dataSource = self;
    self.chart.delegate = self;
    self.chart.userInteractionEnabled = NO;
}

- (void)setStatistics:(NSArray *)statistics {
    if (_statistics != statistics) {
        _statistics = statistics;
    }
    [self updateUI];
}

- (void)updateUI {
    if (_statistics.count > 0) {
        [self.activityIndicatorView stopAnimating];
        [self.chart reloadData];
    } else {
        [self.activityIndicatorView startAnimating];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.chart.pieCenter = CGPointMake(self.chart.bounds.size.width / 2, self.chart.bounds.size.height / 2) ;
    self.chart.pieRadius = self.chart.bounds.size.height / 2;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

#pragma mark - XYPieChartDataSource, XYPieChartDelegate

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return self.statistics.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    HTLStatisticsItem *statisticsItem = self.statistics[index];
    return (CGFloat) statisticsItem.totalTime;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    HTLStatisticsItem *statisticsItem = self.statistics[index];
    HTLMark *mark = statisticsItem.mark;
    return mark.color;
}

@end