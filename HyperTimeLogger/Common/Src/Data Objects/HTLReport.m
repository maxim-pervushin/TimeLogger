//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReport.h"


@implementation HTLReport
@synthesize identifier = identifier_;
@synthesize actionIdentifier = actionIdentifier_;
@synthesize categoryIdentifier = categoryIdentifier_;
@synthesize startDate = startDate_;
@synthesize endDate = endDate_;

#pragma mark - HTLReport

+ (instancetype)reportWithIdentifier:(HTLReportIdentifier)identifier actionIdentifier:(HTLActionIdentifier)actionIdentifier categoryIdentifier:(HTLCategoryIdentifier)categoryIdentifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    return [[self alloc] initWithIdentifier:identifier actionIdentifier:actionIdentifier categoryIdentifier:categoryIdentifier startDate:startDate endDate:endDate];
}

- (instancetype)initWithIdentifier:(HTLReportIdentifier)identifier actionIdentifier:(HTLActionIdentifier)actionIdentifier categoryIdentifier:(HTLCategoryIdentifier)categoryIdentifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    self = [super init];
    if (self) {
        identifier_ = [identifier copy];
        actionIdentifier_ = [actionIdentifier copy];
        categoryIdentifier_ = [categoryIdentifier copy];
        startDate_ = [startDate copy];
        endDate_ = [endDate copy];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    HTLReport *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->identifier_ = identifier_;
        copy->actionIdentifier_ = actionIdentifier_;
        copy->categoryIdentifier_ = categoryIdentifier_;
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
    if (self.actionIdentifier != report.actionIdentifier && ![self.actionIdentifier isEqualToString:report.actionIdentifier])
        return NO;
    if (self.categoryIdentifier != report.categoryIdentifier && ![self.categoryIdentifier isEqualToString:report.categoryIdentifier])
        return NO;
    if (self.startDate != report.startDate && ![self.startDate isEqualToDate:report.startDate])
        return NO;
    if (self.endDate != report.endDate && ![self.endDate isEqualToDate:report.endDate])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.identifier hash];
    hash = hash * 31u + [self.actionIdentifier hash];
    hash = hash * 31u + [self.categoryIdentifier hash];
    hash = hash * 31u + [self.startDate hash];
    hash = hash * 31u + [self.endDate hash];
    return hash;
}

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.identifier=%@", self.identifier];
    [description appendFormat:@", self.actionIdentifier=%@", self.actionIdentifier];
    [description appendFormat:@", self.categoryIdentifier=%@", self.categoryIdentifier];
    [description appendFormat:@", self.startDate=%@", self.startDate];
    [description appendFormat:@", self.endDate=%@", self.endDate];
    [description appendString:@">"];
    return description;
}

@end

