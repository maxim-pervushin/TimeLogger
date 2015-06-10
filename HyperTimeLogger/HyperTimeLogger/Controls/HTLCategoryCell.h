//
// Created by Maxim Pervushin on 01/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HTLCategoryDto;


@interface HTLCategoryCell : UICollectionViewCell

- (void)configureWithCategory:(HTLCategoryDto *)category;

+ (CGFloat)widthWithCategory:(HTLCategoryDto *)category;

@end