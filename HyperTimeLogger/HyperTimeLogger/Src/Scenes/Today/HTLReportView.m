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
@property(nonatomic, weak) IBOutlet UILabel *durationLabel;

@end

@implementation HTLReportView
@dynamic report;

- (HTLReport *)report {
    return _report;
}

- (void)setReport:(HTLReport *)report {
    if (report) {
        _report = [report copy];
    } else {
        _report = nil;
    }
    [self updateUI];
}

- (void)updateUI {
    if (self.report && self.report.mark) {
        self.colorView.backgroundColor = self.report.mark.color;
        self.titleLabel.text = self.report.mark.title;
        self.durationLabel.text = HTLDurationFullString(self.report.duration);
    } else {
        self.colorView.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = @"";
        self.durationLabel.text = @"";
    }
}

@end
