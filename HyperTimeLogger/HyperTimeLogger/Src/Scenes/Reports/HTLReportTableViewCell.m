//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportTableViewCell.h"
#import "HTLReport+Helpers.h"
#import "NSDate+HTL.h"


static NSString *const kDefaultIdentifier = @"HTLReportTableViewCell";
static NSString *const kDefaultIdentifierWithSubtitle = @"HTLReportTableViewCellWithSubtitle";


@interface HTLReportTableViewCell () {
    HTLReport *_report;
}

@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *durationLabel;
@property(nonatomic, weak) IBOutlet UILabel *datesLabel;
@property(nonatomic, weak) IBOutlet UIView *colorView;

@end

@implementation HTLReportTableViewCell
@dynamic report;

+ (NSString *)defaultIdentifier {
    return kDefaultIdentifier;
}

+ (NSString *)defaultIdentifierWithSubtitle {
    return kDefaultIdentifierWithSubtitle;
}

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
        self.titleLabel.text = self.report.mark.title;
        self.subtitleLabel.text = self.report.mark.subtitle;
        self.durationLabel.text = HTLDurationFullString(self.report.duration);
        self.datesLabel.text = [NSString stringWithFormat:@"%@ → %@", self.report.startDate.shortString, self.report.endDate.shortString];
        self.colorView.backgroundColor = self.report.mark.color;
    } else {
        self.titleLabel.text = @"";
        self.subtitleLabel.text = @"";
        self.durationLabel.text = @"";
        self.datesLabel.text = @"";
        self.colorView.backgroundColor = [UIColor blackColor];
    }
}

@end
