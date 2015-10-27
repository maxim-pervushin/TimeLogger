//
// Created by Maxim Pervushin on 09/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLActivityCell.h"
#import "HTLActivity.h"


@interface HTLActivityCell () {
    HTLActivity *activity_;
}

@property(nonatomic, weak) IBOutlet UILabel *activityTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *activitySubTitleLabel;

@end@implementation HTLActivityCell
@dynamic activity;

+ (NSString *)defaultIdentifier {
    return @"HTLActivityCell";
}

+ (NSString *)defaultIdentifierWithSubTitle {
    return @"HTLActivityCellWithSubTitle";
}

- (HTLActivity *)activity {
    return activity_;
}

- (void)setActivity:(HTLActivity *)activity {
    activity_ = [activity copy];
    [self reloadData];
}

- (void)reloadData {
    if (self.activity) {
        self.activityTitleLabel.text = self.activity.title;
        self.activityTitleLabel.textColor = self.activity.color;
        self.activitySubTitleLabel.text = self.activity.subTitle;
        self.activitySubTitleLabel.textColor = self.activity.color;
    } else {
        self.activityTitleLabel.text = @"[ERROR]";
        self.activityTitleLabel.textColor = [UIColor blackColor];
        self.activitySubTitleLabel.text = @"";
        self.activitySubTitleLabel.textColor = [UIColor blackColor];
    }
}

@end