//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportTableViewCell.h"
#import "HTLReport+Helpers.h"
#import "NSDate+HTL.h"


static NSString *const kDefaultIdentifier = @"HTLReportTableViewCell";


@interface HTLReportTableViewCell ()

@property(nonatomic, weak) IBOutlet UILabel *categoryTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *reportDurationLabel;
@property(nonatomic, weak) IBOutlet UIView *categoryColorView;

@end

@implementation HTLReportTableViewCell
@synthesize report = report_;

+ (NSString *)defaultIdentifier {
    return kDefaultIdentifier;
}

- (void)setReport:(HTLReport *)report {
    if (report_ != report) {
        report_ = [report copy];
    }
    [self reloadData];
}

- (void)reloadData {
    if (self.report) {
        self.categoryTitleLabel.text = self.report.mark.title;
        self.categoryTitleLabel.textColor = self.report.mark.color;
        self.reportDurationLabel.text = HTLDurationFullString(self.report.duration);
        self.reportDurationLabel.textColor = self.report.mark.color;
        self.categoryColorView.backgroundColor = self.report.mark.color;
    } else {
        self.categoryTitleLabel.text = @"ERROR";
        self.categoryTitleLabel.textColor = [UIColor blackColor];
        self.reportDurationLabel.text = @"ERROR";
        self.reportDurationLabel.textColor = [UIColor blackColor];
        self.categoryColorView.backgroundColor = [UIColor blackColor];
    }
}

@end
