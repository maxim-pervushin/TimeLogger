//
// Created by Maxim Pervushin on 05/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTLReport;


@interface HTLReportTableViewCell : UITableViewCell

+ (NSString *)defaultIdentifier;

@property (nonatomic, copy) HTLReport *report;

@end