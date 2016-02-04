//
//  HTLAppDelegate.h
//  HyperTimeLogger
//
//  Created by Maxim Pervushin on 29/05/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


#define HTLAppDataManger ((HTLAppDelegate *)[UIApplication sharedApplication].delegate).dataManager
#define HTLAppVersion ((HTLAppDelegate *)[UIApplication sharedApplication].delegate).appVersion


@class HTLDataManager;


static NSString *const kHTLAppDelegateAddReportURLReceived = @"HTLAppDelegateAddReportURLReceived";

@interface HTLAppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, strong) HTLDataManager *dataManager;
@property(nonatomic, readonly) NSString *appVersion;

@end

