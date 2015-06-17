//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDateSectionHeader.h"
#import "HTLDateSectionDto.h"

@interface HTLDateSectionHeader ()

@property(nonatomic, weak) IBOutlet UIView *backgroundColorView;
@property(nonatomic, weak) IBOutlet UILabel *sectionTitleLabel;
@property(nonatomic, weak) IBOutlet UIButton *reportButton;

@property(nonatomic, copy) HTLDateSectionDto *dateSection;

- (IBAction)reportButtonAction:(id)sender;

- (void)initializeUI;

@end

@implementation HTLDateSectionHeader

#pragma mark - HTLDateSectionHeader

- (void)configureWithDateSection:(HTLDateSectionDto *)dateSection {
    self.dateSection = dateSection;
    if (self.dateSection) {
        // TODO: Move formatter somewhere
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateStyle = NSDateFormatterFullStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.dateSection.date];
        self.sectionTitleLabel.text = [formatter stringFromDate:date];
    } else {
        self.sectionTitleLabel.text = @"";
    }
}

- (IBAction)reportButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dateSectionHeader:showStatisticsForDateSection:)]) {
        [self.delegate dateSectionHeader:self showStatisticsForDateSection:self.dateSection];
    }
}

- (void)initializeUI {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColorView.backgroundColor = [UIColor paperColorGray800];
    self.reportButton.backgroundColor = [UIColor clearColor];
    self.reportButton.tintColor = [UIColor paperColorTextLight];
    [self.reportButton setTitleColor:[UIColor paperColorTextLight] forState:UIControlStateNormal];
    [self.reportButton setTitleColor:[UIColor paperColorTextLight] forState:UIControlStateSelected];
    self.sectionTitleLabel.textColor = [UIColor paperColorTextLight];
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