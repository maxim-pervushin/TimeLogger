//
// Created by Maxim Pervushin on 09/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTLActivity;

@interface HTLActivityCell: UICollectionViewCell

+ (NSString *)defaultIdentifier;

+ (NSString *)defaultIdentifierWithSubTitle;

@property (nonatomic, copy) HTLActivity *activity;

@end
