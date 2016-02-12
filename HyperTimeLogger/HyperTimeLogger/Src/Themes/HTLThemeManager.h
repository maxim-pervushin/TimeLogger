//
// Created by Maxim Pervushin on 05/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTLThemeManager : NSObject

@end

@interface HTLTheme : NSObject

@property(nonatomic, readonly) UIColor *controlBackgroundColor;
@property(nonatomic, readonly) UIColor *normalControlTitleColor;
@property(nonatomic, readonly) UIColor *disabledControlTitleColor;

@end

