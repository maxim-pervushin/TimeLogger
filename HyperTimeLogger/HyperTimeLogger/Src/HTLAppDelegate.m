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
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


static NSString *const kAddReportURL = @"timelogger://add";
static NSString *const kApplicationGroup = @"group.timelogger";
static NSString *const kStorageFileName = @"time_logger_storage.db";


@interface HTLAppDelegate ()

- (void)initializeCrashReporter;

- (void)initializeLoggers;

- (void)initializeContentManager;

@end

@implementation HTLAppDelegate

- (void)initializeCrashReporter {
    [Fabric with:@[CrashlyticsKit]];
}

- (void)initializeLoggers {
    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:DDLogLevelDebug];
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:DDLogLevelDebug];
}

- (void)initializeContentManager {
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"VersionIdentifier"];
    NSString *applicationGroup = [NSString stringWithFormat:@"%@%@", kApplicationGroup, [appVersion isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"-%@", appVersion]];
    
    NSURL *storageFolderURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:applicationGroup];
    HTLSqliteStorageProvider *sqliteStorageProvider =
            [HTLSqliteStorageProvider sqliteStorageProviderWithStorageFolderURL:storageFolderURL
                                                                storageFileName:kStorageFileName];
    self.contentManager = [HTLContentManager contentManagerWithStorageProvider:sqliteStorageProvider exportProvider:[HTLCSVStringExportProvider new]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

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
