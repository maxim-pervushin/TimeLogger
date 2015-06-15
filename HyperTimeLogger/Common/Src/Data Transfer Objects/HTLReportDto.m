//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportDto.h"


@implementation HTLReportDto
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

- (id)copyWithZone:(NSZone *)zone {
    HTLReportDto *copy = [[[self class] allocWithZone:zone] init];

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

    return [self isEqualToDto:other];
}

- (BOOL)isEqualToDto:(HTLReportDto *)dto {
    if (self == dto)
        return YES;
    if (dto == nil)
        return NO;
    if (self.identifier != dto.identifier && ![self.identifier isEqualToString:dto.identifier])
        return NO;
    if (self.actionIdentifier != dto.actionIdentifier && ![self.actionIdentifier isEqualToString:dto.actionIdentifier])
        return NO;
    if (self.categoryIdentifier != dto.categoryIdentifier && ![self.categoryIdentifier isEqualToString:dto.categoryIdentifier])
        return NO;
    if (self.startDate != dto.startDate && ![self.startDate isEqualToDate:dto.startDate])
        return NO;
    if (self.endDate != dto.endDate && ![self.endDate isEqualToDate:dto.endDate])
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

@end

