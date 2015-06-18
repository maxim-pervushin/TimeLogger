//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportExtendedCell.h"
#import "HTLActionDto.h"
#import "HTLCategoryDto.h"
#import "HTLReportExtendedDto.h"
#import "HTLReportDto+Helpers.h"

@interface HTLReportExtendedCell ()

@property(nonatomic, weak) IBOutlet UIView *colorView;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property(nonatomic, weak) IBOutlet UILabel *dateLabel;
@property(nonatomic, weak) IBOutlet UILabel *durationLabel;

@end

@implementation HTLReportExtendedCell

- (void)configureWithReport:(HTLReportExtendedDto *)reportExtended {
    NSString *title;
    NSString *category;
    NSString *date;
    NSString *duration;
    UIColor *color;

    if (reportExtended) {
        title = reportExtended.action.title;
        category = reportExtended.category.localizedTitle;
        date = reportExtended.report.endDateString;
        duration = reportExtended.report.durationString;
        color = reportExtended.category.color;
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
}

@end