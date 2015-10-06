//
// Created by Maxim Pervushin on 06/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLCategory.h"

@class HTLCategory;


@interface HTLCategoryEditor : NSObject

@property(nonatomic, copy) HTLCategory *originalCategory;
@property(nonatomic, readonly) BOOL canSave;
@property(nonatomic, readonly) HTLCategory *updatedCategory;

@property(nonatomic, copy) HTLCategoryIdentifier identifier;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIColor *color;

@end