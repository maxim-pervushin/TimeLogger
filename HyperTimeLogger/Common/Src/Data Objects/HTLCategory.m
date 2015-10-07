//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCategory.h"
#import "HTLReport.h"


@implementation HTLCategory
@synthesize identifier = identifier_;
@synthesize title = title_;
@synthesize subTitle = subTitle_;
@synthesize color = color_;

+ (instancetype)categoryWithIdentifier:(HTLCategoryIdentifier)identifier title:(NSString *)title  subTitle:(NSString *)subTitle color:(UIColor *)color {
    return [[self alloc] initWithIdentifier:identifier title:title subTitle:subTitle color:color];
}

- (instancetype)initWithIdentifier:(HTLCategoryIdentifier)identifier title:(NSString *)title  subTitle:(NSString *)subTitle color:(UIColor *)color {
    self = [super init];
    if (self) {
        identifier_ = [identifier copy];
        title_ = [title copy];
        subTitle_ = [subTitle copy];
        color_ = [color copy];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    HTLCategory *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->identifier_ = identifier_;
        copy->title_ = title_;
        copy->subTitle_ = subTitle_;
        copy->color_ = color_;
    }

    return copy;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToCategory:other];
}

- (BOOL)isEqualToCategory:(HTLCategory *)category {
    if (self == category)
        return YES;
    if (category == nil)
        return NO;
    if (self.identifier != category.identifier && ![self.identifier isEqualToString:category.identifier])
        return NO;
    if (self.title != category.title && ![self.title isEqualToString:category.title])
        return NO;
    if (self.subTitle != category.subTitle && ![self.subTitle isEqualToString:category.subTitle])
        return NO;
    if (self.color != category.color && ![self.color isEqual:category.color])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.identifier hash];
    hash = hash * 31u + [self.title hash];
    hash = hash * 31u + [self.subTitle hash];
    hash = hash * 31u + [self.color hash];
    return hash;
}

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.identifier=%@", self.identifier];
    [description appendFormat:@", self.title=%@", self.title];
    [description appendFormat:@", self.subTitle=%@", self.subTitle];
    [description appendFormat:@", self.color=%@", self.color];
    [description appendString:@">"];
    return description;
}

@end
