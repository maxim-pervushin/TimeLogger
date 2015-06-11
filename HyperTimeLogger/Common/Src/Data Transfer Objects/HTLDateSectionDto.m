//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDateSectionDto.h"


@implementation HTLDateSectionDto
@synthesize date = date_;
@synthesize time = time_;
@synthesize zone = zone_;

+ (instancetype)dateSectionWithDate:(NSTimeInterval)date time:(NSTimeInterval)time zone:(NSString *)zone {
    return [[self alloc] initWithDate:date time:time zone:zone];
}

- (instancetype)initWithDate:(NSTimeInterval)date time:(NSTimeInterval)time zone:(NSString *)zone {
    self = [super init];
    if (self) {
        date_ = date;
        time_ = time;
        zone_ = [zone copy];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    HTLDateSectionDto *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->date_ = date_;
        copy->time_ = time_;
        copy->zone_ = zone_;
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

- (BOOL)isEqualToDto:(HTLDateSectionDto *)dto {
    if (self == dto)
        return YES;
    if (dto == nil)
        return NO;
    if (self.date != dto.date)
        return NO;
    if (self.time != dto.time)
        return NO;
    if (self.zone != dto.zone && ![self.zone isEqualToString:dto.zone])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [[NSNumber numberWithDouble:self.date] hash];
    hash = hash * 31u + [[NSNumber numberWithDouble:self.time] hash];
    hash = hash * 31u + [self.zone hash];
    return hash;
}

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.date=%f", self.date];
    [description appendFormat:@", self.time=%f", self.time];
    [description appendFormat:@", self.zone=%@", self.zone];
    [description appendString:@">"];
    return description;
}

@end