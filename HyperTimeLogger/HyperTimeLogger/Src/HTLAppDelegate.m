//
//  HTLAppDelegate.m
//  HyperTimeLogger
//
//  Created by Maxim Pervushin on 29/05/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLAppDelegate.h"
#import "CocoaLumberjack.h"
#import "HTLContentManager.h"
#import "HTLSqliteStorageProvider.h"
#import "HTLCSVStringExportProvider.h"
#import "HyperTimeLogger-Swift.h"
#import "HTLReportExtendedCell.h"
#import "HTLDateSectionHeader.h"
#import "UIColor+FlatColors.h"
#import "HyperTimeLogger-Swift.h"
#import "HTLPieChartCell.h"
#import "HTLStatisticsItemCell.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


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
@dynamic appVersion;

- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kVersionIdentifierKey];
}

- (void)initializeAppearance {
//    [UIView appearance].tintColor = [UIColor flatCloudsColor];
    [UIView appearanceWhenContainedInInstancesOfClasses:@[HTLBackgroundView.class]].tintColor = [UIColor flatCloudsColor];
    [UIButton appearance].backgroundColor = [UIColor flatAsbestosColor];
    [HTLLineView appearance].backgroundColor = [UIColor flatConcreteColor];
    [HTLBackgroundView appearance].backgroundColor = [UIColor flatCloudsColor];

    [HTLLightBackgroundView appearance].backgroundColor = [UIColor flatCloudsColor];
    [UIButton appearanceWhenContainedInInstancesOfClasses:@[[HTLLightBackgroundView class]]].backgroundColor = [UIColor flatAsbestosColor];
    [UIButton appearanceWhenContainedInInstancesOfClasses:@[[HTLLightBackgroundView class]]].tintColor = [UIColor flatCloudsColor];
    [[UIButton appearanceWhenContainedInInstancesOfClasses:@[[HTLLightBackgroundView class]]] setTitleColor:[UIColor flatCloudsColor]
                                                                                          forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedInInstancesOfClasses:@[[HTLLightBackgroundView class]]] setTitleColor:[UIColor flatCloudsColor]
                                                                                          forState:UIControlStateDisabled];

    [HTLTopBarView appearance].backgroundColor = [UIColor flatAsbestosColor];
    [HTLReportExtendedCell appearance].backgroundColor = [UIColor clearColor];

    [HTLPieChartCell appearance].backgroundColor = [UIColor clearColor];
    [HTLStatisticsItemCell appearance].backgroundColor = [UIColor clearColor];

    [HTLNoContentCell appearance].backgroundColor = [UIColor clearColor];
    [UILabel appearance].textColor = [UIColor flatAsbestosColor];

    [HTLAddButtonWidget appearance].backgroundColor = [[UIColor flatAsbestosColor] colorWithAlphaComponent:0.75];
    [HTLRoundedImageView appearanceWhenContainedInInstancesOfClasses:@[[HTLAddButtonWidget class]]].backgroundColor = [UIColor flatAsbestosColor];
    [UILabel appearanceWhenContainedInInstancesOfClasses:@[[HTLAddButtonWidget class]]].textColor = [UIColor flatCloudsColor];

    [UILabel appearanceWhenContainedInInstancesOfClasses:@[[HTLTopBarView class]]].textColor = [UIColor flatCloudsColor];
    [UIButton appearanceWhenContainedInInstancesOfClasses:@[[HTLTopBarView class]]].backgroundColor = [UIColor clearColor];
    [UIButton appearanceWhenContainedInInstancesOfClasses:@[[HTLTopBarView class]]].tintColor = [UIColor flatCloudsColor];
}

- (void)initializeCrashReporter {
    [Fabric with:@[CrashlyticsKit]];
}

- (void)initializeLoggers {
    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:DDLogLevelDebug];
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:DDLogLevelDebug];
}

- (void)initializeContentManager {
    NSString *applicationGroup = [NSString stringWithFormat:@"%@%@", kApplicationGroup, [self.appVersion isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"-%@", self.appVersion]];
    NSURL *storageFolderURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:applicationGroup];
    HTLSqliteStorageProvider *sqliteStorageProvider =
            [HTLSqliteStorageProvider sqliteStorageProviderWithStorageFolderURL:storageFolderURL
                                                                storageFileName:kStorageFileName];
    self.contentManager = [HTLContentManager contentManagerWithStorageProvider:sqliteStorageProvider exportProvider:[HTLCSVStringExportProvider new]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeAppearance];
    [self initializeCrashReporter];
    [self initializeLoggers];
    [self initializeContentManager];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.absoluteString isEqualToString:kAddReportURL]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHTLAppDelegateAddReportURLReceived object:nil];
    }
    return YES;
}

@end
