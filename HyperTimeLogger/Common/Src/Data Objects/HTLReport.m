//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReport.h"


@implementation HTLReport
@synthesize mark = mark_;
@synthesize startDate = startDate_;
@synthesize endDate = endDate_;

#pragma mark - HTLReport

+ (instancetype)reportWithMark:(HTLMark *)mark startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    return [[self alloc] initWithMark:mark startDate:startDate endDate:endDate];
}

- (instancetype)initWithMark:(HTLMark *)mark startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    self = [super init];
    if (self) {
        mark_ = [mark copy];
        startDate_ = [startDate copy];
        endDate_ = [endDate copy];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    HTLReport *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->mark_ = mark_;
        copy->startDate_ = startDate_;
        copy->endDate_ = endDate_;
    }

    return copy;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToReport:other];
}

- (BOOL)isEqualToReport:(HTLReport *)report {
    if (self == report)
        return YES;
    if (report == nil)
        return NO;
    if (self.mark != report.mark && ![self.mark isEqual:report.mark])
        return NO;
    if (self.startDate != report.startDate && ![self.startDate isEqualToDate:report.startDate])
        return NO;
    if (self.endDate != report.endDate && ![self.endDate isEqualToDate:report.endDate])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.mark hash];
    hash = hash * 31u + [self.startDate hash];
    hash = hash * 31u + [self.endDate hash];
    return hash;
}

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.mark=%@", self.mark];
    [description appendFormat:@", self.startDate=%@", self.startDate];
    [description appendFormat:@", self.endDate=%@", self.endDate];
    [description appendString:@">"];
    return description;
}

@end

