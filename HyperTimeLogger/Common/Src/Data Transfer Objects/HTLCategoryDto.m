//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCategoryDto.h"


@implementation HTLCategoryDto
@synthesize identifier = identifier_;
@synthesize title = title_;
@synthesize color = color_;

+ (instancetype)categoryWithIdentifier:(HTLCategoryIdentifier)identifier title:(NSString *)title color:(UIColor *)color {
    return [[self alloc] initWithIdentifier:identifier title:title color:color];
}

- (instancetype)initWithIdentifier:(HTLCategoryIdentifier)identifier title:(NSString *)title color:(UIColor *)color {
    self = [super init];
    if (self) {
        identifier_ = [identifier copy];
        title_ = [title copy];
        color_ = [color copy];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    HTLCategoryDto *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->identifier_ = identifier_;
        copy->title_ = title_;
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

- (BOOL)isEqualToCategory:(HTLCategoryDto *)category {
    if (self == category)
        return YES;
    if (category == nil)
        return NO;
    if (self.identifier != category.identifier && ![self.identifier isEqualToString:category.identifier])
        return NO;
    if (self.title != category.title && ![self.title isEqualToString:category.title])
        return NO;
    if (self.color != category.color && ![self.color isEqual:category.color])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.identifier hash];
    hash = hash * 31u + [self.title hash];
    hash = hash * 31u + [self.color hash];
    return hash;
}

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.identifier=%@", self.identifier];
    [description appendFormat:@", self.title=%@", self.title];
    [description appendFormat:@", self.color=%@", self.color];
    [description appendString:@">"];
    return description;
}

@end

@implementation HTLCategoryDto (Localized)

- (NSString *)localizedTitle {
    return NSLocalizedString(self.title, nil);
}

@end