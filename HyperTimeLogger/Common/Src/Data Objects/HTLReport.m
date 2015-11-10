//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReport.h"


@implementation HTLReport
@synthesize identifier = identifier_;
@synthesize mark = mark_;
@synthesize startDate = startDate_;
@synthesize endDate = endDate_;

#pragma mark - HTLReport

+ (instancetype)reportWithIdentifier:(NSString *)identifier mark:(HTLMark *)mark startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    return [[self alloc] initWithIdentifier:identifier mark:mark startDate:startDate endDate:endDate];
}

+ (instancetype)reportWithMark:(HTLMark *)mark startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    return [self reportWithIdentifier:[NSUUID UUID].UUIDString mark:mark startDate:startDate endDate:endDate];
}

- (instancetype)initWithIdentifier:(NSString *)identifier mark:(HTLMark *)mark startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    if (identifier.length == 0) {
        return nil;
    }

    self = [super init];
    if (self) {
        identifier_ = [identifier copy];
        mark_ = [mark copy];
        startDate_ = [startDate copy];
        endDate_ = [endDate copy];
    }
    return self;

}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    HTLReport *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->identifier_ = identifier_;
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
    if (self.identifier != report.identifier && ![self.identifier isEqualToString:report.identifier])
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
    NSUInteger hash = [self.identifier hash];
    hash = hash * 31u + [self.mark hash];
    hash = hash * 31u + [self.startDate hash];
    hash = hash * 31u + [self.endDate hash];
    return hash;
}

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.identifier=%@", self.identifier];
    [description appendFormat:@", self.mark=%@", self.mark];
    [description appendFormat:@", self.startDate=%@", self.startDate];
    [description appendFormat:@", self.endDate=%@", self.endDate];
    [description appendString:@">"];
    return description;
}

@end

