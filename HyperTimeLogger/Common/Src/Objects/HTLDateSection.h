//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTLDateSection : NSObject <NSCopying>

+ (instancetype)dateSectionWithDateString:(NSString *)dateString timeString:(NSString *)timeString timeZone:(NSString *)timeZone;

- (instancetype)initWithDateString:(NSString *)dateString timeString:(NSString *)timeString timeZone:(NSString *)timeZone;

- (id)copyWithZone:(NSZone *)zone;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToDto:(HTLDateSection *)dto;

- (NSUInteger)hash;

- (NSString *)description;

@property (nonatomic, readonly) NSString *dateString;
@property (nonatomic, readonly) NSString *timeString;
@property (nonatomic, readonly) NSString *timeZoneString;

@end


@interface HTLDateSection (Helpers)

@property (nonatomic, readonly) NSString *fulldateStringLocalized;

@end
