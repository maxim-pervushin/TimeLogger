//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NSString *HTLCategoryIdentifier;


// TODO: Rename to Activity?
@interface HTLCategory : NSObject <NSCopying, NSObject>

+ (instancetype)categoryWithIdentifier:(HTLCategoryIdentifier)identifier title:(NSString *)title subTitle:(NSString *)subTitle color:(UIColor *)color;

@property(nonatomic, readonly) HTLCategoryIdentifier identifier;
@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) NSString *subTitle;
@property(nonatomic, readonly) UIColor *color;

@end
