//
// Created by Maxim Pervushin on 06/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HTLReport;
@class HTLReportEditor;
@protocol HTLEditReportTableViewControllerDelegate;


@interface HTLEditReportTableViewController : UITableViewController

@property(nonatomic, weak) id <HTLEditReportTableViewControllerDelegate> delegate;
@property(nonatomic, readonly) HTLReportEditor *reportEditor;

@end

@protocol HTLEditReportTableViewControllerDelegate

- (void)editReportTableViewControllerDidCancel:(HTLEditReportTableViewController *)viewController;
- (void)editReportTableViewController:(HTLEditReportTableViewController *)viewController didFinishEditingWithReport:(HTLReport *)report;

@end