//
// Created by Maxim Pervushin on 05/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTLDateSection : NSObject <NSCopying, NSObject>

+ (instancetype)dateSectionWithDateString:(NSString *)dateString timeString:(NSString *)timeString timeZone:(NSString *)timeZone;

@property(nonatomic, readonly) NSString *dateString;
// TODO: Do we need time and timeZone here?
@property(nonatomic, readonly) NSString *timeString;
@property(nonatomic, readonly) NSString *timeZoneString;

@end


@interface HTLDateSection (Helpers)

@property(nonatomic, readonly) NSString *fulldateStringLocalized;

@end
