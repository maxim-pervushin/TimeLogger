//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDateSection.h"
#import "NSDate+HTLComponents.h"


@implementation HTLDateSection
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

- (id)copyWithZone:(nullable NSZone *)zone {
    HTLDateSection *copy = [[[self class] allocWithZone:zone] init];

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

    return [self isEqualToSection:other];
}

- (BOOL)isEqualToSection:(HTLDateSection *)section {
    if (self == section)
        return YES;
    if (section == nil)
        return NO;
    if (self.dateString != section.dateString && ![self.dateString isEqualToString:section.dateString])
        return NO;
    if (self.timeString != section.timeString && ![self.timeString isEqualToString:section.timeString])
        return NO;
    if (self.timeZoneString != section.timeZoneString && ![self.timeZoneString isEqualToString:section.timeZoneString])
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

@implementation HTLDateSection (Helpers)

+ (NSDateFormatter *)fullFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterFullStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    return formatter;
}

- (NSString *)fulldateStringLocalized {
    // TODO: Replace self.timeString and self.timeZoneString with empty strings.
    return [[HTLDateSection fullFormatter] stringFromDate:[NSDate dateWithDateString:self.dateString timeString:self.timeString timeZoneString:self.timeZoneString]];
}

@end
