//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLCategoryDto.h"
#import "HTLStatisticsItemCell.h"

@implementation HTLStatisticsItemDto
@synthesize category = category_;
@synthesize totalTime = totalTime_;

#pragma mark - HTLStatisticsItemDto

+ (instancetype)statisticsItemWithCategory:(HTLCategoryDto *)category totalTime:(NSTimeInterval)totalTime {
    return [[self alloc] initWithCategory:category totalTime:totalTime];
}

- (instancetype)initWithCategory:(HTLCategoryDto *)category totalTime:(NSTimeInterval)totalTime {
    self = [super init];
    if (self) {
        category_ = [category copy];
        totalTime_ = totalTime;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    HTLStatisticsItemDto *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->category_ = category_;
        copy->totalTime_ = totalTime_;
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

- (BOOL)isEqualToDto:(HTLStatisticsItemDto *)dto {
    if (self == dto)
        return YES;
    if (dto == nil)
        return NO;
    if (self.category != dto.category && ![self.category isEqualToCategory:dto.category])
        return NO;
    if (self.totalTime != dto.totalTime)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.category hash];
    hash = hash * 31u + [[NSNumber numberWithDouble:self.totalTime] hash];
    return hash;
}

@end