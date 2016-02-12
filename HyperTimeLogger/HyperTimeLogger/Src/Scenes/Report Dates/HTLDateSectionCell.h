//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTLDateSection;


@interface HTLDateSectionCell : UITableViewCell

+ (NSString *)defaultIdentifier;

@property (nonatomic, copy) HTLDateSection *dateSection;

@end