//
// Created by Maxim Pervushin on 09/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLMarkCollectionViewCell.h"
#import "HTLMark.h"


@interface HTLMarkCollectionViewCell () {
    HTLMark *_mark;
}

@property(nonatomic, weak) IBOutlet UILabel *markTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *markSubTitleLabel;

@end

@implementation HTLMarkCollectionViewCell
@dynamic mark;

+ (NSString *)defaultIdentifier {
    return @"HTLMarkCollectionViewCell";
}

+ (NSString *)defaultIdentifierWithSubTitle {
    return @"HTLMarkCellWithSubTitle";
}

- (HTLMark *)mark {
    return _mark;
}

- (void)setMark:(HTLMark *)mark {
    _mark = [mark copy];
    [self reloadData];
}

- (void)reloadData {
    if (self.mark) {
        self.markTitleLabel.text = self.mark.title;
        self.markTitleLabel.textColor = self.mark.color;
        if (self.mark.subtitle.length > 0) {
            self.markTitleLabel.accessibilityIdentifier = [NSString stringWithFormat:@"%@ %@", self.mark.title, self.mark.subtitle];
        } else {
            self.markTitleLabel.accessibilityIdentifier = self.mark.title;
        }
        self.markSubTitleLabel.text = self.mark.subtitle;
        self.markSubTitleLabel.textColor = self.mark.color;
        self.backgroundColor = [self.mark.color colorWithAlphaComponent:0.15];
    } else {
        self.markTitleLabel.text = @"";
        self.markTitleLabel.textColor = [UIColor blackColor];
        self.markTitleLabel.accessibilityIdentifier = nil;
        self.markSubTitleLabel.text = @"";
        self.markSubTitleLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
//        self.backgroundView.accessibilityIdentifier = nil;
    }
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.backgroundColor = [UIColor blackColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end

@interface HTLMarkTableViewCell () {
    HTLMark *_mark;
}

@property(nonatomic, weak) IBOutlet UILabel *markTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *markSubTitleLabel;

@end

@implementation HTLMarkTableViewCell
@dynamic mark;

+ (NSString *)defaultIdentifier {
    return @"HTLMarkTableViewCell";
}

+ (NSString *)defaultIdentifierWithSubTitle {
    return @"HTLMarkTableViewCellWithSubTitle";
}

- (HTLMark *)mark {
    return _mark;
}

- (void)setMark:(HTLMark *)mark {
    _mark = [mark copy];
    [self reloadData];
}

- (void)reloadData {
    if (self.mark) {
        self.markTitleLabel.text = self.mark.title;
        self.markTitleLabel.textColor = self.mark.color;
        self.markSubTitleLabel.text = self.mark.subtitle;
        self.markSubTitleLabel.textColor = self.mark.color;
    } else {
        self.markTitleLabel.text = @"[ERROR]";
        self.markTitleLabel.textColor = [UIColor blackColor];
        self.markSubTitleLabel.text = @"";
        self.markSubTitleLabel.textColor = [UIColor blackColor];
    }
}

@end