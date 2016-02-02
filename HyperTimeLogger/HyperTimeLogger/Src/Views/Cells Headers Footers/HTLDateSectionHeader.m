//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDateSectionHeader.h"
#import "HTLDateSectionDto.h"
#import "UIColor+FlatColors.h"

@interface HTLDateSectionHeader ()

//@property(nonatomic, weak) IBOutlet UIView *backgroundColorView;
@property(nonatomic, weak) IBOutlet UILabel *sectionTitleLabel;
@property(nonatomic, weak) IBOutlet UIButton *statisticsButton;

@property(nonatomic, copy) HTLDateSectionDto *dateSection;

- (IBAction)statisticsButtonAction:(id)sender;

- (void)initializeUI;

@end

@implementation HTLDateSectionHeader

#pragma mark - HTLDateSectionHeader

- (void)configureWithDateSection:(HTLDateSectionDto *)dateSection {
    self.dateSection = dateSection;
    if (self.dateSection) {
        self.sectionTitleLabel.text = self.dateSection.fulldateStringLocalized;
    } else {
        self.sectionTitleLabel.text = @"";
    }
}

- (IBAction)statisticsButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dateSectionHeader:showStatisticsForDateSection:)]) {
        [self.delegate dateSectionHeader:self showStatisticsForDateSection:self.dateSection];
    }
}

- (void)initializeUI {
//    self.contentView.backgroundColor = [UIColor clearColor];
//    self.backgroundColorView.backgroundColor = [UIColor paperColorGray800];
    UIImage *image = [[UIImage imageNamed:@"statistics.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.statisticsButton setImage:image forState:UIControlStateNormal];
    [self.statisticsButton setImage:image forState:UIControlStateSelected];
//    self.statisticsButton.backgroundColor = [UIColor clearColor];
//    self.statisticsButton.tintColor = [UIColor flatAsbestosColor];
//    self.sectionTitleLabel.textColor = [UIColor flatCloudsColor];
}

#pragma mark - UIView

- (void)awakeFromNib {
    [self initializeUI];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeUI];
    }
    return self;
}

@end