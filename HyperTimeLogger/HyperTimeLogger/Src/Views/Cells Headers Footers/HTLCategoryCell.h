//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HTLCategory;


@interface HTLCategoryCell : UICollectionViewCell

- (void)configureWithCategory:(HTLCategory *)category;

+ (CGFloat)widthWithCategory:(HTLCategory *)category;

@end