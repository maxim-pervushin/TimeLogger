//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTLCategory;
@class HTLEditCategoryViewController;


@protocol HTLEditCategoryViewControllerDelegate

- (void)editCategoryViewController:(HTLEditCategoryViewController *)viewController finishedWithCategory:(HTLCategory *)category;

@end

@interface HTLEditCategoryViewController : UITableViewController

@property(nonatomic, weak) id <HTLEditCategoryViewControllerDelegate> delegate;
@property(nonatomic, copy) HTLCategory *originalCategory;

@end