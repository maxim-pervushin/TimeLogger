//
// Created by Maxim Pervushin on 10/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLDebugTableViewController.h"
#import "HyperTimeLogger-Swift.h"
#import "NSDate+HTL.h"


@interface HTLDebugTableViewController () <HTLDatePickerViewControllerDelegate>

@property(weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation HTLDebugTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *) segue.destinationViewController;
        if ([navigationController.topViewController isKindOfClass:[HTLDatePickerViewController class]]) {
            HTLDatePickerViewController *datePickerViewController = (HTLDatePickerViewController *) navigationController.topViewController;
            datePickerViewController.datePickerDelegate = self;
        }
    }
}

#pragma mark - HTLDatePickerViewControllerDelegate

- (void)datePickerViewControllerDidCancel:(HTLDatePickerViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)datePickerViewController:(HTLDatePickerViewController *)viewController didPickDate:(NSDate *)date {
    self.dateLabel.text = date.mediumString;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end