//
// Created by Maxim Pervushin on 05/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *HTLDurationFullString(NSTimeInterval timeInterval);

@interface NSDate (HTL)

- (NSString *)shortString;

- (NSString *)mediumString;

- (NSString *)stringWithFormat:(NSString *)format;

@end