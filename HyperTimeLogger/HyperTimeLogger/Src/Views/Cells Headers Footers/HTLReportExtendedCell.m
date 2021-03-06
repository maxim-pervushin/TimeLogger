//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportExtendedCell.h"
#import "HTLAction.h"
#import "HTLCategory.h"
#import "HTLReportExtended.h"
#import "HTLReport+HTLHelpers.h"
#import "NSDate+HTLTimeHelpers.h"

@interface HTLReportExtendedCell ()

@property(nonatomic, weak) IBOutlet UIView *colorView;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property(nonatomic, weak) IBOutlet UILabel *dateLabel;
@property(nonatomic, weak) IBOutlet UILabel *durationLabel;

@end

@implementation HTLReportExtendedCell

- (void)configureWithReport:(HTLReportExtended *)reportExtended {
    NSString *title;
    NSString *category;
    NSString *date;
    NSString *duration;
    UIColor *color;
    UIColor *backgroundColor;

    if (reportExtended) {
        title = reportExtended.action.title;
        category = reportExtended.category.localizedTitle;
        date = [NSDate stringWithStartDate:reportExtended.report.startDate endDate:reportExtended.report.endDate];
        duration = htlStringWithTimeInterval(reportExtended.report.duration);
        color = reportExtended.category.color;
        backgroundColor = [reportExtended.category.color colorWithAlphaComponent:0.15];
    }

    self.titleLabel.text = title;
    self.categoryLabel.text = category;
    self.dateLabel.text = date;
    self.durationLabel.text = duration;
    self.colorView.backgroundColor = color;
    self.titleLabel.textColor = color;
    self.categoryLabel.textColor = color;
    self.dateLabel.textColor = color;
    self.durationLabel.textColor = color;
    self.backgroundColor = backgroundColor;
}

@end