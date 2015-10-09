//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLActivity.h"

@class HTLActivity;


@interface HTLCategoryEditor : NSObject

@property(nonatomic, copy) HTLActivity *originalCategory;
@property(nonatomic, readonly) BOOL canSave;
@property(nonatomic, readonly) HTLActivity *updatedCategory;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subTitle;
@property(nonatomic, strong) UIColor *color;

@end