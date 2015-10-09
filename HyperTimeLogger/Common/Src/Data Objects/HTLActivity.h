//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HTLActivity : NSObject <NSCopying, NSObject>

+ (instancetype)categoryWithTitle:(NSString *)title subTitle:(NSString *)subTitle color:(UIColor *)color;

@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) NSString *subTitle;
@property(nonatomic, readonly) UIColor *color;

@end
