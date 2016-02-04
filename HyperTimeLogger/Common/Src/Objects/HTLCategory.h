//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NSString *HTLCategoryIdentifier;


@interface HTLCategory : NSObject <NSCopying>

+ (instancetype)categoryWithIdentifier:(HTLCategoryIdentifier)identifier title:(NSString *)title color:(UIColor *)color;

- (instancetype)initWithIdentifier:(HTLCategoryIdentifier)identifier title:(NSString *)title color:(UIColor *)color;

- (id)copyWithZone:(NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToCategory:(HTLCategory *)category;

- (NSUInteger)hash;

- (NSString *)description;

@property(nonatomic, readonly) HTLCategoryIdentifier identifier;
@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) UIColor *color;

@end


@interface HTLCategory (Localized)

@property(nonatomic, readonly) NSString *localizedTitle;

@end
