//
// Created by Maxim Pervushin on 04/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLSettingsViewController.h"
#import "HTLSettingsDataSource.h"
#import "HTLSettingsDataSource+TestData.h"
#import "HTLAppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface HTLSettingsViewController () <MFMailComposeViewControllerDelegate> {
    HTLSettingsDataSource *_dataSource;
}

@property(nonatomic, weak) IBOutlet UIButton *exportToCSVButton;
@property(nonatomic, weak) IBOutlet UIView *generateTestDataContainer;
@property(nonatomic, weak) IBOutlet UIButton *generateTestDataButton;

@property(nonatomic, readonly) HTLSettingsDataSource *dataSource;

- (IBAction)doneButtonAction:(id)sender;

- (IBAction)resetContentButtonAction:(id)sender;

- (IBAction)resetDefaultsButtonAction:(id)sender;

- (IBAction)exportToCSVButtonAction:(id)sender;

- (IBAction)generateTestDataButtonAction:(id)sender;

- (void)generateTestData;

@end

@implementation HTLSettingsViewController

#pragma mark - HTLSettingsViewController @IB

- (IBAction)doneButtonAction:(id)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)resetContentButtonAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Reset content", nil)
                                                                             message:NSLocalizedString(@"Are you sure want to reset all data?", nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Reset", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf.dataSource resetContent];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)resetDefaultsButtonAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Reset defaults", nil)
                                                                             message:NSLocalizedString(@"Are you sure want to reset all defaults?", nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Reset", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf.dataSource resetDefaults];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)exportToCSVButtonAction:(id)sender {
    NSString *csv = [self.dataSource exportDataToCSV];
    if (csv.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Export to CSV", nil)
                                                                                 message:NSLocalizedString(@"There is no data to export.", nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Export to CSV", nil)
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        __weak __typeof(self) weakSelf = self;

        if ([MFMailComposeViewController canSendMail]) {
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Send Mail", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self sendMailCSV:csv];
            }]];
        }

        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Copy to Pasteboard", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf copyCSV:csv];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];

        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)generateTestDataButtonAction:(id)sender {
    [self generateTestData];
}

#pragma mark - HTLSettingsViewController

- (HTLSettingsDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [HTLSettingsDataSource dataSourceWithDataChangedBlock:nil];
    }
    return _dataSource;
}

- (void)generateTestData {
    [self.dataSource generateTestData];
}

- (void)sendMailCSV:(NSString *)csv {
    MFMailComposeViewController *mailComposeViewController = [MFMailComposeViewController new];
    mailComposeViewController.mailComposeDelegate = self;
    [mailComposeViewController setSubject:NSLocalizedString(@"Data export from Time Logger", nil)];
    [mailComposeViewController setMessageBody:NSLocalizedString(@"Look at files attached", nil) isHTML:NO];
    [mailComposeViewController addAttachmentData:[csv dataUsingEncoding:NSUTF8StringEncoding]
                                        mimeType:@"text/csv"
                                        fileName:@"export.csv"];
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
}

- (void)copyCSV:(NSString *)csv {
    [UIPasteboard generalPasteboard].string = csv;
}

#pragma mark - UIViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.generateTestDataContainer.hidden = [HTLAppVersion isEqualToString:@""];
//    self.generateTestDataButton.hidden = [HTLAppVersion isEqualToString:@""];
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.exportToCSVButton.hidden = ![MFMailComposeViewController canSendMail];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        DDLogError(@"%@", error.localizedDescription);
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end

