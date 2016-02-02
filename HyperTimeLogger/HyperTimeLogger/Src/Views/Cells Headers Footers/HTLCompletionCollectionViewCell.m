//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCompletionCollectionViewCell.h"
#import "HTLCompletionDto.h"
#import "UIColor+BFPaperColors.h"
#import "HTLCategoryDto.h"
#import "HTLActionDto.h"

@interface HTLCompletionCollectionViewCell ()

@property(nonatomic, weak) IBOutlet UILabel *actionTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *categoryTitleLabel;

@end


@implementation HTLCompletionCollectionViewCell

- (void)configureWithCompletion:(HTLCompletionDto *)completion {
    if (completion) {
        self.actionTitleLabel.text = completion.action.title;
        self.categoryTitleLabel.text = completion.category.localizedTitle;
//        self.backgroundColor = completion.category.color;
        self.backgroundColor = [completion.category.color colorWithAlphaComponent:0.15];
//        UIColor *textColor = [UIColor isColorDark:self.backgroundColor] ? [UIColor paperColorTextLight] : [UIColor paperColorTextDark];
        self.actionTitleLabel.textColor = completion.category.color;
        self.categoryTitleLabel.textColor = completion.category.color;

    } else {
        self.actionTitleLabel.text = @"";
        self.categoryTitleLabel.text = @"";
        self.backgroundColor = [UIColor clearColor];
    }
}

@end