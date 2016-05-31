//
//  HTLAppDelegate.m
//  HyperTimeLogger
//
//  Created by Maxim Pervushin on 29/05/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLAppDelegate.h"
#import "HTLDataManager.h"
#import "HTLSqliteStorageProvider.h"
#import "HTLCSVStringExportProvider.h"
#import "HTLReportExtendedCell.h"
#import "UIColor+FlatColors.h"
#import "HTLPieChartCell.h"
#import "HTLStatisticsItemCell.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "HyperTimeLogger-Swift.h"
#import "HTLRemindersManager.h"


static NSString *const kAddReportURL = @"timelogger://add";
static NSString *const kVersionIdentifierKey = @"VersionIdentifier";
static NSString *const kApplicationGroup = @"group.timelogger";
static NSString *const kStorageFileName = @"time_logger_storage.db";

@interface HTLAppDelegate ()

- (void)initializeAppearance;

- (void)initializeCrashReporter;

- (void)initializeLoggers;

- (void)initializeContentManager;

@end

@implementation HTLAppDelegate
@dynamic versionIdentifier;

- (NSString *)versionIdentifier {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kVersionIdentifierKey];
}

- (void)initializeAppearance {

    [HTLButton appearance].backgroundColor = [UIColor flatAsbestosColor];
    [HTLButton appearance].tintColor = [UIColor flatCloudsColor];

    [HTLNavigationBar appearance].tintColor = [UIColor flatCloudsColor];
    [HTLNavigationBar appearance].barTintColor = [UIColor flatAsbestosColor];
    [HTLNavigationBar appearance].barStyle = UIBarStyleBlack;

    [HTLTableViewCell appearance].backgroundColor = [UIColor flatAsbestosColor];


    [HTLLineView appearance].backgroundColor = [UIColor flatConcreteColor];

    [HTLLightLabel appearance].textColor = [UIColor flatCloudsColor];
    [UILabel appearance].textColor = [UIColor flatAsbestosColor];

    [HTLReportExtendedCell appearance].backgroundColor = [UIColor clearColor];

    [HTLPieChartCell appearance].backgroundColor = [UIColor clearColor];

    [HTLStatisticsItemCell appearance].backgroundColor = [UIColor clearColor];

    [HTLNoContentCell appearance].backgroundColor = [UIColor clearColor];

    [HTLBackgroundView appearance].backgroundColor = [UIColor flatCloudsColor];
//    [UIView appearanceWhenContainedInInstancesOfClasses:@[HTLBackgroundView.class]].tintColor = [UIColor flatCloudsColor];


    [HTLLightBackgroundView appearance].backgroundColor = [UIColor flatCloudsColor];
    [UIButton appearanceWhenContainedInInstancesOfClasses:@[[HTLLightBackgroundView class]]].backgroundColor = [UIColor flatAsbestosColor];
    [UIButton appearanceWhenContainedInInstancesOfClasses:@[[HTLLightBackgroundView class]]].tintColor = [UIColor flatCloudsColor];
    [[UIButton appearanceWhenContainedInInstancesOfClasses:@[[HTLLightBackgroundView class]]] setTitleColor:[UIColor flatCloudsColor]
                                                                                                   forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedInInstancesOfClasses:@[[HTLLightBackgroundView class]]] setTitleColor:[UIColor flatCloudsColor]
                                                                                                   forState:UIControlStateDisabled];

    // HTLTextField
    [HTLTextField appearance].textColor = [UIColor flatWetAsphaltColor];
    [HTLTextField appearance].tintColor = [UIColor flatWetAsphaltColor];
    [HTLTextField appearance].placeholderTextColor = [[UIColor flatWetAsphaltColor] colorWithAlphaComponent:0.3];
    [HTLTextField appearance].backgroundColor = [UIColor clearColor];
    [UIView appearanceWhenContainedInInstancesOfClasses:@[HTLTextField.class]].tintColor = [UIColor flatWetAsphaltColor];;

    [HTLTopBarView appearance].backgroundColor = [UIColor flatAsbestosColor];
    [UILabel appearanceWhenContainedInInstancesOfClasses:@[[HTLTopBarView class]]].textColor = [UIColor flatCloudsColor];
    [UIButton appearanceWhenContainedInInstancesOfClasses:@[[HTLTopBarView class]]].backgroundColor = [UIColor clearColor];
    [UIButton appearanceWhenContainedInInstancesOfClasses:@[[HTLTopBarView class]]].tintColor = [UIColor flatCloudsColor];

    [HTLAddButtonWidget appearance].backgroundColor = [[UIColor flatAsbestosColor] colorWithAlphaComponent:0.75];
    [HTLRoundedImageView appearanceWhenContainedInInstancesOfClasses:@[[HTLAddButtonWidget class]]].backgroundColor = [UIColor flatAsbestosColor];
    [UILabel appearanceWhenContainedInInstancesOfClasses:@[[HTLAddButtonWidget class]]].textColor = [UIColor flatCloudsColor];
}

- (void)initializeCrashReporter {
    [Fabric with:@[CrashlyticsKit]];
}

- (void)initializeLoggers {
    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:DDLogLevelDebug];
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:DDLogLevelDebug];
}

- (void)initializeContentManager {
    NSString *applicationGroup = [NSString stringWithFormat:@"%@%@", kApplicationGroup, [self.versionIdentifier isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"-%@", self.versionIdentifier]];
    NSURL *storageFolderURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:applicationGroup];
    HTLSqliteStorageProvider *sqliteStorageProvider =
            [HTLSqliteStorageProvider sqliteStorageProviderWithStorageFolderURL:storageFolderURL
                                                                storageFileName:kStorageFileName];
    self.dataManager = [HTLDataManager contentManagerWithStorageProvider:sqliteStorageProvider exportProvider:[HTLCSVStringExportProvider new]];
}

- (void)initializeRemindersManager {
    self.remindersManager = [HTLRemindersManager new];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeAppearance];
    [self initializeCrashReporter];
    [self initializeLoggers];
    [self initializeContentManager];
    [self initializeRemindersManager];

    if (nil != launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHTLAppDelegateAddReportURLReceived object:nil];
    }

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.absoluteString isEqualToString:kAddReportURL]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHTLAppDelegateAddReportURLReceived object:nil];
    }
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
}

@end
