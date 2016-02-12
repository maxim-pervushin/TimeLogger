//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDateSectionCell.h"
#import "HTLDateSection.h"

static NSString *const kDefaultIdentifier = @"HTLDateSectionCell";


@interface HTLDateSectionCell ()

@property(nonatomic, weak) IBOutlet UILabel *dateSectionDateLabel;

@end

@implementation HTLDateSectionCell
@synthesize dateSection = dateSection_;

+ (NSString *)defaultIdentifier {
    return kDefaultIdentifier;
}

- (void)setDateSection:(HTLDateSection *)dateSection {
    if (dateSection_ != dateSection) {
        dateSection_ = [dateSection copy];
    }
    [self reloadData];
}

- (void)reloadData {
    if (self.dateSection) {
        self.dateSectionDateLabel.text = self.dateSection.dateString;
    } else {
        self.dateSectionDateLabel.text = @"ERROR";
    }
}

@end