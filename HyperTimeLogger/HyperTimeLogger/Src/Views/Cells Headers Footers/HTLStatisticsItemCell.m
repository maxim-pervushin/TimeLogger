//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStatisticsItemCell.h"
#import "HTLCategory.h"
#import "NSDate+HTLTimeHelpers.h"


@interface HTLStatisticsItemCell ()

@property(nonatomic, weak) IBOutlet UILabel *categoryTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property(nonatomic, weak) IBOutlet UILabel *totalReportsLabel;
@property(nonatomic, weak) IBOutlet UILabel *categoryPercentageLabel;

@end


@implementation HTLStatisticsItemCell

- (void)configureWithStatisticsItem:(HTLStatisticsItem *)statisticsItem totalTime:(NSTimeInterval)totalTime {
    if (statisticsItem) {
        self.categoryTitleLabel.text = statisticsItem.category.localizedTitle;
        self.totalTimeLabel.text = htlStringWithTimeInterval(statisticsItem.totalTime);
        self.totalReportsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Reports: %lu", nil), (unsigned long)statisticsItem.totalReports];
        self.categoryPercentageLabel.text = [NSString stringWithFormat:@"%.1f %%", statisticsItem.totalTime / totalTime * 100];
        self.categoryTitleLabel.textColor = statisticsItem.category.color;
        self.totalTimeLabel.textColor = statisticsItem.category.color;
        self.totalReportsLabel.textColor = statisticsItem.category.color;
        self.categoryPercentageLabel.textColor = statisticsItem.category.color;
        self.backgroundColor = [statisticsItem.category.color colorWithAlphaComponent:0.15];

    } else {
        self.categoryTitleLabel.text = @"";
        self.totalTimeLabel.text = @"";
        self.totalReportsLabel.text = @"";
        self.categoryPercentageLabel.text = @"";
        self.categoryTitleLabel.textColor = [UIColor blackColor];
        self.totalTimeLabel.textColor = [UIColor blackColor];
        self.totalReportsLabel.textColor = [UIColor blackColor];
        self.categoryPercentageLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
