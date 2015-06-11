//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HTLReportExtendedDto;


@interface HTLReportExtendedCell : UITableViewCell

- (void)configureWithReport:(HTLReportExtendedDto *)reportExtended;

@end