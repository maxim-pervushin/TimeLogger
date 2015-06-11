//
// Created by Maxim Pervushin on 31/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLActionDto.h"


@implementation HTLActionDto
@synthesize identifier = identifier_;
@synthesize title = title_;

+ (instancetype)actionWithIdentifier:(HTLActionIdentifier)identifier title:(NSString *)title {
    return [[self alloc] initWithIdentifier:identifier title:title];
}

- (instancetype)initWithIdentifier:(HTLActionIdentifier)identifier title:(NSString *)title {
    self = [super init];
    if (self) {
        identifier_ = [identifier copy];
        title_ = [title copy];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    HTLActionDto *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->identifier_ = identifier_;
        copy->title_ = title_;
    }

    return copy;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToAction:other];
}

- (BOOL)isEqualToAction:(HTLActionDto *)action {
    if (self == action)
        return YES;
    if (action == nil)
        return NO;
    if (self.identifier != action.identifier && ![self.identifier isEqualToString:action.identifier])
        return NO;
    if (self.title != action.title && ![self.title isEqualToString:action.title])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.identifier hash];
    hash = hash * 31u + [self.title hash];
    return hash;
}

@end