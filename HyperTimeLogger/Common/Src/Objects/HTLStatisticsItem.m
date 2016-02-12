//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCategory.h"
#import "HTLStatisticsItemCell.h"

@implementation HTLStatisticsItem
@synthesize category = category_;
@synthesize totalTime = totalTime_;
@synthesize totalReports = totalReports_;

#pragma mark - HTLStatisticsItemDto

+ (instancetype)statisticsItemWithCategory:(HTLCategory *)category totalTime:(NSTimeInterval)totalTime totalReports:(NSUInteger)totalReports {
    return [[self alloc] initWithCategory:category totalTime:totalTime totalReports:totalReports];
}

- (instancetype)initWithCategory:(HTLCategory *)category totalTime:(NSTimeInterval)totalTime totalReports:(NSUInteger)totalReports {
    self = [super init];
    if (self) {
        category_ = [category copy];
        totalTime_ = totalTime;
        totalReports_ = totalReports;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    HTLStatisticsItem *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->category_ = category_;
        copy->totalTime_ = totalTime_;
        copy->totalReports_ = totalReports_;
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

- (BOOL)isEqualToDto:(HTLStatisticsItem *)dto {
    if (self == dto)
        return YES;
    if (dto == nil)
        return NO;
    if (self.category != dto.category && ![self.category isEqualToCategory:dto.category])
        return NO;
    if (self.totalTime != dto.totalTime)
        return NO;
    if (self.totalReports != dto.totalReports)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.category hash];
    hash = hash * 31u + [[NSNumber numberWithDouble:self.totalTime] hash];
    hash = hash * 31u + self.totalReports;
    return hash;
}

@end