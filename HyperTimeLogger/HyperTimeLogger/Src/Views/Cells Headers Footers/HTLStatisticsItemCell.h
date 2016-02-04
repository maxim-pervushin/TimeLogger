//
// Created by Maxim Pervushin on 17/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIkit/UIkit.h>
#include "HTLStatisticsItem.h"


@class HTLCategory;


@interface HTLStatisticsItemCell : UITableViewCell

- (void)configureWithStatisticsItem:(HTLStatisticsItem *)statisticsItem totalTime:(NSTimeInterval)totalTime;

@end


