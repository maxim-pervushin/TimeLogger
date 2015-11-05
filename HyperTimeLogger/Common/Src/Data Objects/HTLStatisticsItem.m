//
// Created by Maxim Pervushin on 07/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStatisticsItem.h"
#import "HTLMark.h"


@implementation HTLStatisticsItem
@synthesize mark = mark_;
@synthesize totalTime = totalTime_;
@synthesize totalReports = totalReports_;

+ (instancetype)statisticsItemWithMark:(HTLMark *)mark totalTime:(NSTimeInterval)totalTime totalReports:(NSUInteger)totalReports {
    return [[self alloc] initWithCategory:mark totalTime:totalTime totalReports:totalReports];

}

- (instancetype)initWithCategory:(HTLMark *)category totalTime:(NSTimeInterval)totalTime totalReports:(NSUInteger)totalReports {
    self = [super init];
    if (self) {
        mark_ = [category copy];
        totalTime_ = totalTime;
        totalReports_ = totalReports;
    }
    return self;
}


#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    HTLStatisticsItem *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->mark_ = mark_;
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

    return [self isEqualToItem:other];
}

- (BOOL)isEqualToItem:(HTLStatisticsItem *)item {
    if (self == item)
        return YES;
    if (item == nil)
        return NO;
    if (self.mark != item.mark && ![self.mark isEqual:item.mark])
        return NO;
    if (self.totalTime != item.totalTime)
        return NO;
    if (self.totalReports != item.totalReports)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.mark hash];
    hash = hash * 31u + [[NSNumber numberWithDouble:self.totalTime] hash];
    hash = hash * 31u + self.totalReports;
    return hash;
}

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.mark=%@", self.mark];
    [description appendFormat:@", self.totalTime=%lf", self.totalTime];
    [description appendFormat:@", self.totalReports=%u", self.totalReports];
    [description appendString:@">"];
    return description;
}


@end