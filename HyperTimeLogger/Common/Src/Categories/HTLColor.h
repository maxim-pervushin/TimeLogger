//
// Created by Maxim Pervushin on 05/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

@interface HTLColor: NSObject <NSObject, NSCopying>

+ (NSArray *)colors;

+ (instancetype)colorWithColor:(UIColor *)color name:(NSString *)name;

- (NSString *)description;

@property (nonatomic, copy) UIColor *color;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) UIColor *textColor;
@property (nonatomic, readonly) NSString *identifier;

@end
