//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCategoryCell_New.h"
#import "HTLCategory.h"


static NSString *const kDefaultIdentifier = @"HTLCategoryCell";


@interface HTLCategoryCell_New ()

@property(nonatomic, weak) IBOutlet UILabel *categoryTitleLabel;
@property(nonatomic, weak) IBOutlet UIView *categoryColorView;

@end

@implementation HTLCategoryCell_New
@synthesize category = category_;

+ (NSString *)defaultIdentifier {
    return kDefaultIdentifier;
}

- (void)setCategory:(HTLCategory *)category {
    if (category_ != category) {
        category_ = [category copy];
    }
    [self reloadData];
}

- (void)reloadData {
    if (self.category) {
        self.categoryTitleLabel.text = self.category.localizedTitle;
        self.categoryTitleLabel.textColor = self.category.color;
        self.categoryColorView.backgroundColor = self.category.color;
    } else {
         self.categoryTitleLabel.text = @"ERROR";
         self.categoryTitleLabel.textColor = [UIColor blackColor];
         self.categoryColorView.backgroundColor = [UIColor blackColor];
    }
}

@end
