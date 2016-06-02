//
// Created by Maxim Pervushin on 30/05/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import "HTLRemindersManager.h"


static const int kMaxLocalNotificationsNumber = 64;
static const int kDefaultInterval = 60 * 30;
static NSString *const kLocalNotificationCategory = @"HTLLocalNotificationCategory";
static NSString *const kRemindersEnabledKey = @"RemindersEnabled";
static NSString *const kRemindersIntervalKey = @"RemindersInterval";

@implementation HTLRemindersManager
@dynamic enabled;
@dynamic interval;

#pragma mark - HTLRemindersManager public

- (void)setEnabled:(BOOL)enabled {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:enabled forKey:kRemindersEnabledKey];
    [defaults synchronize];
    [self reload];
}

- (BOOL)isEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kRemindersEnabledKey];
}

- (void)setInterval:(NSTimeInterval)interval {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:interval forKey:kRemindersIntervalKey];
    [defaults synchronize];
    [self reload];
}

- (NSTimeInterval)interval {
    NSTimeInterval result = [[NSUserDefaults standardUserDefaults] doubleForKey:kRemindersIntervalKey];
    if (0 == result) {
        result = kDefaultInterval;
    }
    return result;
}

- (void)reload {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    if (!self.isEnabled) {
        return;
    }

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:[[NSSet alloc] initWithArray:@[[self userNotificationCategory]]]]];
    }

    NSTimeInterval reminderInterval = [self interval];
    NSMutableArray *notifications = [NSMutableArray new];
    for (int i = 0; i < kMaxLocalNotificationsNumber; i++) {
        UILocalNotification *localNotification = [UILocalNotification new];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(i * reminderInterval)];
        localNotification.timeZone = [NSTimeZone localTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertTitle = [[NSBundle mainBundle] localizedInfoDictionary][@"CFBundleDisplayName"];
        localNotification.alertBody = NSLocalizedString(@"Don't forget to log your activities!", @"");
        localNotification.hasAction = YES;
        [notifications addObject:localNotification];
    }
    [[UIApplication sharedApplication] setScheduledLocalNotifications:notifications];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reload];
    }
    return self;
}

#pragma mark - HTLRemindersManager private

- (UIUserNotificationCategory *)userNotificationCategory {
    UIMutableUserNotificationAction *yesAction = [UIMutableUserNotificationAction new];
    yesAction.identifier = @"HTLYesAction";
    yesAction.title = @"Yes";
    yesAction.destructive = NO;
    yesAction.activationMode = UIUserNotificationActivationModeBackground;
    yesAction.authenticationRequired = YES;

    UIMutableUserNotificationCategory *category = [UIMutableUserNotificationCategory new];
    category.identifier = kLocalNotificationCategory;
    [category setActions:@[yesAction] forContext:UIUserNotificationActionContextDefault];
    [category setActions:@[yesAction] forContext:UIUserNotificationActionContextMinimal];

    return [category copy];
}

@end