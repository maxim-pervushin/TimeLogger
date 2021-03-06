//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HTLDateSection;
@protocol HTLDateSectionHeaderDelegate;


@interface HTLDateSectionHeader : UITableViewHeaderFooterView

@property(nonatomic, weak) id <HTLDateSectionHeaderDelegate> delegate;

- (void)configureWithDateSection:(HTLDateSection *)dateSection;

@end


@protocol HTLDateSectionHeaderDelegate <NSObject>

- (void)dateSectionHeader:(HTLDateSectionHeader *)dateSectionHeader showStatisticsForDateSection:(HTLDateSection *)dateSection;

@end