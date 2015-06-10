//
//  HTLAppDelegate.m
//  HyperTimeLogger
//
//  Created by Maxim Pervushin on 29/05/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLAppDelegate.h"
#import "CocoaLumberjack.h"


static NSString *const kAddReportURL = @"timelogger://add";


@interface HTLAppDelegate ()

- (void)initializeLoggers;

@end

@implementation HTLAppDelegate

- (void)initializeLoggers {
    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:DDLogLevelDebug];
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:DDLogLevelDebug];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeLoggers];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.absoluteString isEqualToString:kAddReportURL]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHTLAppDelegateAddReportURLReceived object:nil];
    }
    return YES;
}

@end
