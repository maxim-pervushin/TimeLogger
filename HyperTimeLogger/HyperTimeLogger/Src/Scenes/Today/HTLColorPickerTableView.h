//
// Created by Maxim Pervushin on 02/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTLColor;


@interface HTLColorPickerTableView : UITableView

@property(nonatomic, copy) UIColor *color;

@end

@interface HTLColorTableViewCell : UITableViewCell

+ (NSString *)defaultIdentifier;

@property(nonatomic, strong) HTLColor *color;

@end

