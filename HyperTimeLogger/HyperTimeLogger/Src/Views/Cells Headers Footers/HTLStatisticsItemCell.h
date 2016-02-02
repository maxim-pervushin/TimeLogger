//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIkit/UIkit.h>
#include "HTLStatisticsItemDto.h"


@class HTLCategoryDto;


@interface HTLStatisticsItemCell : UITableViewCell

- (void)configureWithStatisticsItem:(HTLStatisticsItemDto *)statisticsItem totalTime:(NSTimeInterval)totalTime;

@end


