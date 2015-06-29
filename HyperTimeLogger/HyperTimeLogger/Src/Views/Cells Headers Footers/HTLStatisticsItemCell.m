//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStatisticsItemCell.h"
#import "HTLCategoryDto.h"


@interface HTLStatisticsItemCell ()

@property(nonatomic, weak) IBOutlet UILabel *categoryTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property(nonatomic, weak) IBOutlet UILabel *totalReportsLabel;

- (NSString *)descriptionForTimeInterval:(NSTimeInterval)timeInterval;

@end


@implementation HTLStatisticsItemCell

- (NSString *)descriptionForTimeInterval:(NSTimeInterval)timeInterval {
    NSInteger ti = (NSInteger) timeInterval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long) hours, (long) minutes, (long) seconds];
}

- (void)configureWithStatisticsItem:(HTLStatisticsItemDto *)statisticsItem {
    if (statisticsItem) {
        self.categoryTitleLabel.text = statisticsItem.category.localizedTitle;
        self.totalTimeLabel.text = [self descriptionForTimeInterval:statisticsItem.totalTime];
        self.totalReportsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Reports: %lu", nil), (unsigned long)statisticsItem.totalReports];
        self.categoryTitleLabel.textColor = statisticsItem.category.color;
        self.totalTimeLabel.textColor = statisticsItem.category.color;
        self.totalReportsLabel.textColor = statisticsItem.category.color;

    } else {
        self.categoryTitleLabel.text = @"";
        self.totalTimeLabel.text = @"";
        self.totalReportsLabel.text = @"";
        self.categoryTitleLabel.textColor = [UIColor blackColor];
        self.totalTimeLabel.textColor = [UIColor blackColor];
        self.totalReportsLabel.textColor = [UIColor blackColor];
    }
}

@end


