//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDateSectionDto.h"
#import "NSDate+HTLComponents.h"


@implementation HTLDateSectionDto
@synthesize dateString = dateString_;
@synthesize timeString = timeString_;
@synthesize timeZoneString = timeZoneString_;

+ (instancetype)dateSectionWithDateString:(NSString *)dateString timeString:(NSString *)timeString timeZone:(NSString *)timeZone {
    return [[self alloc] initWithDateString:dateString timeString:timeString timeZone:timeZone];
}

- (instancetype)initWithDateString:(NSString *)dateString timeString:(NSString *)timeString timeZone:(NSString *)timeZone {
    self = [super init];
    if (self) {
        dateString_ = [dateString copy];
        timeString_ = [timeString copy];
        timeZoneString_ = [timeZone copy];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    HTLDateSectionDto *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->dateString_ = dateString_;
        copy->timeString_ = timeString_;
        copy->timeZoneString_ = timeZoneString_;
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
    if (self.dateString != dto.dateString && ![self.dateString isEqualToString:dto.dateString])
        return NO;
    if (self.timeString != dto.timeString && ![self.timeString isEqualToString:dto.timeString])
        return NO;
    if (self.timeZoneString != dto.timeZoneString && ![self.timeZoneString isEqualToString:dto.timeZoneString])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.dateString hash];
    hash = hash * 31u + [self.timeString hash];
    hash = hash * 31u + [self.timeZoneString hash];
    return hash;
}

#pragma mark - Description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.dateString=%@", self.dateString];
    [description appendFormat:@", self.timeString=%@", self.timeString];
    [description appendFormat:@", self.timeZoneString=%@", self.timeZoneString];
    [description appendString:@">"];
    return description;
}

@end

@implementation HTLDateSectionDto (Helpers)

+ (NSDateFormatter *)fullFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterFullStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    return formatter;
}

- (NSString *)fulldateStringLocalized {
    return [[HTLDateSectionDto fullFormatter] stringFromDate:[NSDate dateWithDateString:self.dateString timeString:self.timeString timeZoneString:self.timeZoneString]];
}

@end
