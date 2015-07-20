//
// Created by Maxim Pervushin on 02/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCompletionTableViewCell.h"
#import "HTLCompletionDto.h"
#import "HTLActionDto.h"
#import "HTLCategoryDto.h"
#import "UIColor+BFPaperColors.h"

@interface HTLCompletionTableViewCell ()

@property(nonatomic, weak) IBOutlet UILabel *actionTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *categoryTitleLabel;

@end

@implementation HTLCompletionTableViewCell

- (void)configureWithCompletion:(HTLCompletionDto *)completion {
    if (completion) {
        self.actionTitleLabel.text = completion.action.title;
        self.categoryTitleLabel.text = completion.category.localizedTitle;
        self.backgroundColor = completion.category.color;
        UIColor *textColor = [UIColor isColorDark:self.backgroundColor] ? [UIColor paperColorTextLight] : [UIColor paperColorTextDark];
        self.actionTitleLabel.textColor = textColor;
        self.categoryTitleLabel.textColor = textColor;

    } else {
        self.actionTitleLabel.text = @"";
        self.categoryTitleLabel.text = @"";
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end