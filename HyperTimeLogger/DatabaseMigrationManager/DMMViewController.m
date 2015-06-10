//
//  DMMViewController.m
//  DatabaseMigrationManager
//
//  Created by Maxim Pervushin on 09/06/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "DMMViewController.h"
#import <MessageUI/MessageUI.h>


static NSString *const kApplicationGroup = @"group.timelogger";
static NSString *const kStorageFileName = @"time_logger_storage.db";


@interface DMMViewController () <MFMailComposeViewControllerDelegate>

- (IBAction)exportSqliteDatabase:(id)sender;

- (NSURL *)storageFileFolderURL;
- (NSString *)storageFilePath;

@end

@implementation DMMViewController


- (IBAction)exportSqliteDatabase:(id)sender {
    NSData *data = [NSData dataWithContentsOfFile:self.storageFilePath];
    MFMailComposeViewController *mailComposeViewController = [MFMailComposeViewController new];
    mailComposeViewController.mailComposeDelegate = self;
    [mailComposeViewController setSubject:@"Data export from Time Logger"];
    [mailComposeViewController setMessageBody:@"Look at files attached" isHTML:NO];
    [mailComposeViewController addAttachmentData:data
                                        mimeType:@"text/csv"
                                        fileName:@"time_logger_storage.db"];
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
}

- (NSURL *)storageFileFolderURL {
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kApplicationGroup];
}

- (NSString *)storageFilePath {
    return [self.storageFileFolderURL URLByAppendingPathComponent:kStorageFileName].path;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
