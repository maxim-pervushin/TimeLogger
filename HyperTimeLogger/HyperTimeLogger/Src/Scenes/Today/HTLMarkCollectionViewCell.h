//
// Created by Maxim Pervushin on 09/10/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTLMark;

@interface HTLMarkCollectionViewCell : UICollectionViewCell

+ (NSString *)defaultIdentifier;

+ (NSString *)defaultIdentifierWithSubTitle;

@property (nonatomic, copy) HTLMark *mark;

@end


@interface HTLMarkTableViewCell : UITableViewCell

+ (NSString *)defaultIdentifier;

+ (NSString *)defaultIdentifierWithSubTitle;

@property (nonatomic, copy) HTLMark *mark;

@end
