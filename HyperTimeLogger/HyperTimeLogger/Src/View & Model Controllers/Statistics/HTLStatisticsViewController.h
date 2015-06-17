//
// Created by Maxim Pervushin on 08/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HTLCategoryDto;


@interface HTLStatisticsViewController : UIViewController
@end

@interface HTLStatisticsModelController : NSObject

@property(nonatomic, copy) NSDate *fromDate;
@property(nonatomic, copy) NSDate *toDate;

@property(nonatomic, readonly) NSArray *categories;

- (NSTimeInterval)totalTimeForCategory:(HTLCategoryDto *)category;

@end


