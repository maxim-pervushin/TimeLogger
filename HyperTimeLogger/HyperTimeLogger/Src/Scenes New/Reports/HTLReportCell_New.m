//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportCell_New.h"
#import "HTLReportExtended.h"
#import "HTLReport+Helpers.h"
#import "HTLCategory.h"


static NSString *const kDefaultIdentifier = @"HTLReportCell";


@interface HTLReportCell_New ()

@property(nonatomic, weak) IBOutlet UILabel *categoryTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *reportDurationLabel;
@property(nonatomic, weak) IBOutlet UIView *categoryColorView;

@end

@implementation HTLReportCell_New
@synthesize report = report_;

+ (NSString *)defaultIdentifier {
    return kDefaultIdentifier;
}

- (void)setReport:(HTLReportExtended *)report {
    if (report_ != report) {
        report_ = [report copy];
    }
    [self reloadData];
}

- (void)reloadData {
    if (self.report) {
        self.categoryTitleLabel.text = self.report.category.title;
        self.categoryTitleLabel.textColor = self.report.category.color;
        self.reportDurationLabel.text = self.report.report.durationString;
        self.reportDurationLabel.textColor = self.report.category.color;
        self.categoryColorView.backgroundColor = self.report.category.color;
    } else {
        self.categoryTitleLabel.text = @"ERROR";
        self.categoryTitleLabel.textColor = [UIColor blackColor];
        self.reportDurationLabel.text = @"ERROR";
        self.reportDurationLabel.textColor = [UIColor blackColor];
        self.categoryColorView.backgroundColor = [UIColor blackColor];
    }
}

@end
