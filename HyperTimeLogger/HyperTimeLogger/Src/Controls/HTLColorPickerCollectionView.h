//
// Created by Maxim Pervushin on 06/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HTLColor;
@protocol HTLColorPickerCollectionViewDelegate;


@interface HTLColorPickerCollectionView : UICollectionView

@property(nonatomic, weak) id <HTLColorPickerCollectionViewDelegate> colorPickerDelegate;
@property(nonatomic, strong) UIColor *color;

@end


// TODO: Move to separate file.
@interface HTLColorCollectionViewCell : UICollectionViewCell

+ (NSString *)defaultIdentifier;

@property(nonatomic, strong) HTLColor *color;

@end


@protocol HTLColorPickerCollectionViewDelegate

- (void)colorPickerCollectionView:(HTLColorPickerCollectionView *)colorPickerCollectionView didSelectColor:(UIColor *)color;

@end
