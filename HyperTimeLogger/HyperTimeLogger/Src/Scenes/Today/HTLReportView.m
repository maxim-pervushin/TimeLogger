//
// Created by Maxim Pervushin on 03/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#include "HTLReportView.h"
#import "HTLReport+Helpers.h"
#import "NSDate+HTL.h"


@interface HTLReportView () {
    HTLReport *_report;
}

@property(nonatomic, weak) IBOutlet UIView *colorView;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *durationLabel;
@property(nonatomic, weak) IBOutlet UILabel *datesLabel;

@end

@implementation HTLReportView
@dynamic report;

- (HTLReport *)report {
    return _report;
}

- (void)setReport:(HTLReport *)report {
    if (_report != report) {
        _report = [report copy];
    }
    [self updateUI];
}

- (void)updateUI {
    if (self.report && self.report.mark) {
        self.colorView.backgroundColor = self.report.mark.color;
        self.titleLabel.text = self.report.mark.title;
        self.subtitleLabel.text = self.report.mark.subtitle;
        self.durationLabel.text = HTLDurationFullString(self.report.duration);
        self.datesLabel.text = [NSString stringWithFormat:@"%@ → %@", self.report.startDate.shortString, self.report.endDate.shortString];
    } else {
        self.colorView.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = @"";
        self.subtitleLabel.text = @"";
        self.durationLabel.text = @"";
        self.datesLabel.text = @"";
    }
}

@end
