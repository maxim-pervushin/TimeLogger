//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTLDateSection;
@class HTLReportDateListViewController;

@protocol HTLReportDateListViewControllerDelegate

- (void)reportDateListViewController:(HTLReportDateListViewController *)viewController didSelectedDateSection:(HTLDateSection *)dateSection;

@end

@interface HTLReportDateListViewController : UITableViewController

@property(nonatomic, weak) id <HTLReportDateListViewControllerDelegate> delegate;
@property(nonatomic, copy) HTLDateSection *selectedDateSection;

@end