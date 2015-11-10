//
//  HTLAppDelegate.m
//  HyperTimeLogger
//
//  Created by Maxim Pervushin on 29/05/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLAppDelegate.h"
#import "HTLContentManager.h"
#import "HTLCSVStringExportProvider.h"
#import "HTLMemoryStorageProvider.h"
#import "HTLThemeManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


static NSString *const kAddReportURL = @"timelogger://add";
static NSString *const kVersionIdentifierKey = @"VersionIdentifier";
static NSString *const kApplicationGroup = @"group.timelogger";
static NSString *const kStorageFileName = @"time_logger_storage.db";

@interface HTLAppDelegate ()

- (void)initializeCrashReporter;

- (void)initializeLoggers;

- (void)initializeContentManager;

@end

@implementation HTLAppDelegate
@dynamic appVersion;

- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kVersionIdentifierKey];
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
//    NSURL *storageFolderURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:applicationGroup];
//    HTLSqliteStorageProvider *sqliteStorageProvider =
//            [HTLSqliteStorageProvider sqliteStorageProviderWithStorageFolderURL:storageFolderURL
//                                                                storageFileName:kStorageFileName];
//    self.contentManager = [HTLContentManager contentManagerWithStorageProvider:sqliteStorageProvider exportProvider:[HTLCSVStringExportProvider new]];

    HTLMemoryStorageProvider *storageProvider = [HTLMemoryStorageProvider new];
    self.contentManager = [HTLContentManager contentManagerWithStorageProvider:storageProvider exportProvider:[HTLCSVStringExportProvider new]];
    storageProvider.changesObserver = self.contentManager;
}

- (void)initializeThemeManager {
    self.themeManager = [HTLThemeManager new];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self initializeCrashReporter];
    [self initializeLoggers];
    [self initializeContentManager];
    [self initializeThemeManager];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.absoluteString isEqualToString:kAddReportURL]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHTLAppDelegateAddReportURLReceived object:nil];
    }
    return YES;
}

@end
