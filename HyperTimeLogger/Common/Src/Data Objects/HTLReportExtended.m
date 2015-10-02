//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportExtended.h"
#import "HTLAction.h"
#import "HTLCategory.h"
#import "HTLDateSection.h"
#import "HTLReport.h"


@implementation HTLReportExtended
@synthesize report = report_;
@synthesize action = action_;
@synthesize category = category_;

#pragma mark - HTLReportExtendedDto

+ (instancetype)reportExtendedWithReport:(HTLReport *)report action:(HTLAction *)action category:(HTLCategory *)category {
    return [[self alloc] initWithReport:report action:action category:category];
}

- (instancetype)initWithReport:(HTLReport *)report action:(HTLAction *)action category:(HTLCategory *)category {
    if (!report || !action || !category) {
        return nil;
    }

    self = [super init];
    if (self) {
        report_ = [report copy];
        action_ = [action copy];
        category_ = [category copy];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    HTLReportExtended *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->report_ = report_;
        copy->action_ = action_;
        copy->category_ = category_;
    }

    return copy;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToExtended:other];
}

- (BOOL)isEqualToExtended:(HTLReportExtended *)extended {
    if (self == extended)
        return YES;
    if (extended == nil)
        return NO;
    if (self.report != extended.report && ![self.report isEqualToReport:extended.report])
        return NO;
    if (self.action != extended.action && ![self.action isEqualToAction:extended.action])
        return NO;
    if (self.category != extended.category && ![self.category isEqualToCategory:extended.category])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.report hash];
    hash = hash * 31u + [self.action hash];
    hash = hash * 31u + [self.category hash];
    return hash;
}

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.report=%@", self.report];
    [description appendFormat:@", self.action=%@", self.action];
    [description appendFormat:@", self.category=%@", self.category];
    [description appendString:@">"];
    return description;
}

@end

