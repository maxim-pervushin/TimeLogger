//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportExtendedDto.h"
#import "HTLActionDto.h"
#import "HTLCategoryDto.h"
#import "HTLDateSectionDto.h"
#import "HTLReportDto.h"


@implementation HTLReportExtendedDto
@synthesize report = report_;
@synthesize action = action_;
@synthesize category = category_;

#pragma mark - HTLReportExtendedDto

+ (instancetype)reportExtendedWithReport:(HTLReportDto *)report action:(HTLActionDto *)action category:(HTLCategoryDto *)category {
    return [[self alloc] initWithReport:report action:action category:category];
}

- (instancetype)initWithReport:(HTLReportDto *)report action:(HTLActionDto *)action category:(HTLCategoryDto *)category {
    if (!report || !action || !category) {
        return nil;
    }

    self = [super init];
    if (self) {
        report_ = [report copy];
        action_ = [action copy];
        category_ = [category copy];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    HTLReportExtendedDto *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->report_ = report_;
        copy->action_ = action_;
        copy->category_ = category_;
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

- (BOOL)isEqualToDto:(HTLReportExtendedDto *)dto {
    if (self == dto)
        return YES;
    if (dto == nil)
        return NO;
    if (self.report != dto.report && ![self.report isEqualToDto:dto.report])
        return NO;
    if (self.action != dto.action && ![self.action isEqualToAction:dto.action])
        return NO;
    if (self.category != dto.category && ![self.category isEqualToCategory:dto.category])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.report hash];
    hash = hash * 31u + [self.action hash];
    hash = hash * 31u + [self.category hash];
    return hash;
}

@end

