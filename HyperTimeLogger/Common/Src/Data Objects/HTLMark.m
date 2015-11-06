//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLMark.h"
#import "HTLReport.h"


@implementation HTLMark
@synthesize title = title_;
@synthesize subtitle = subTitle_;
@synthesize color = color_;

+ (instancetype)markWithTitle:(NSString *)title subTitle:(NSString *)subTitle color:(UIColor *)color {
    return [[self alloc] initWithTitle:title subTitle:subTitle color:color];
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle color:(UIColor *)color {
    self = [super init];
    if (self) {
        title_ = [title copy];
        subTitle_ = [subTitle copy];
        color_ = [color copy];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    HTLMark *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
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

    return [self isEqualToActivity:other];
}

- (BOOL)isEqualToActivity:(HTLMark *)activity {
    if (self == activity)
        return YES;
    if (activity == nil)
        return NO;
    if (self.title != activity.title && ![self.title isEqualToString:activity.title])
        return NO;
    if (self.subtitle != activity.subtitle && ![self.subtitle isEqualToString:activity.subtitle])
        return NO;
    if (self.color != activity.color && ![self.color isEqual:activity.color])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.title hash];
    hash = hash * 31u + [self.subtitle hash];
    hash = hash * 31u + [self.color hash];
    return hash;
}

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.title=%@", self.title];
    [description appendFormat:@", self.subtitle=%@", self.subtitle];
    [description appendFormat:@", self.color=%@", self.color];
    [description appendString:@">"];
    return description;
}

@end
