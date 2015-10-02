//
// Created by Maxim Pervushin on 02/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCompletion.h"
#import "HTLCategory.h"
#import "HTLAction.h"


@implementation HTLCompletion
@synthesize action = action_;
@synthesize category = category_;
@synthesize weight = weight_;

+ (instancetype)completionWithAction:(HTLAction *)action category:(HTLCategory *)category weight:(NSUInteger)weight {
    return [[self alloc] initWithAction:action category:category weight:weight];
}

- (instancetype)initWithAction:(HTLAction *)action category:(HTLCategory *)category weight:(NSUInteger)weight {
    if (!action || !category) {
        return nil;
    }

    self = [super init];
    if (self) {
        action_ = [action copy];
        category_ = [category copy];
        weight_ = weight;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    HTLCompletion *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->action_ = action_;
        copy->category_ = category_;
        copy->weight_ = weight_;
    }

    return copy;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToCompletion:other];
}

- (BOOL)isEqualToCompletion:(HTLCompletion *)completion {
    if (self == completion)
        return YES;
    if (completion == nil)
        return NO;
    if (self.action != completion.action && ![self.action isEqualToAction:completion.action])
        return NO;
    if (self.category != completion.category && ![self.category isEqualToCategory:completion.category])
        return NO;
    if (self.weight != completion.weight)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.action hash];
    hash = hash * 31u + [self.category hash];
    hash = hash * 31u + self.weight;
    return hash;
}

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.action=%@", self.action];
    [description appendFormat:@", self.category=%@", self.category];
    [description appendFormat:@", self.weight=%u", self.weight];
    [description appendString:@">"];
    return description;
}

@end