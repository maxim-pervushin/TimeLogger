//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCategoryCell.h"
#import "HTLCategory.h"
#import "UIColor+BFPaperColors.h"

@interface HTLCategoryCell ()

@property(nonatomic, weak) IBOutlet UIView *selectionView;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation HTLCategoryCell

- (void)configureWithCategory:(HTLCategory *)category {
    self.titleLabel.text = category ? category.localizedTitle : @"";
    self.titleLabel.textColor = category ? category.color : [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.selectionView.backgroundColor = [UIColor paperColorTextDarkDivider];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1f];
    } else {
        self.selectionView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
}

+ (CGFloat)widthWithCategory:(HTLCategory *)category {
    if (category) {
        return [category.localizedTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]}].width + 24;
    }
    return 0;
}

@end