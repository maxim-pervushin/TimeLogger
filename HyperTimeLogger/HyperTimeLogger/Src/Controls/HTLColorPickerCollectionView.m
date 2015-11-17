//
// Created by Maxim Pervushin on 06/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLColorPickerCollectionView.h"
#import "HTLColor.h"

@interface HTLColorPickerCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation HTLColorPickerCollectionView
@dynamic color;

#pragma mark - HTLColorPickerCollectionView

- (UIColor *)color {
    NSIndexPath *selectedIndexPath = [[self indexPathsForSelectedItems] firstObject];
    if (!selectedIndexPath) {
        [self selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        return ((HTLColor *) [HTLColor colors][0]).color;
    }
    return ((HTLColor *) [HTLColor colors][(NSUInteger) selectedIndexPath.row]).color;
}

- (void)setColor:(UIColor *)color {
    NSInteger index = -1;
    for (NSInteger i = 0; i < [HTLColor colors].count; i++) {
        HTLColor *element = [HTLColor colors][(NSUInteger) i];
        if ([element.color isEqual:color]) {
            index = i;
            break;
        }
    }

    if (index == -1) {
        index = 0;
    }

    if ([HTLColor colors].count > 0) {
        [self selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)commonInit {
    self.dataSource = self;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    [self selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark - UICollectionViewController

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - UIViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[HTLColor colors] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTLColorCollectionViewCell *cell = (HTLColorCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:[HTLColorCollectionViewCell defaultIdentifier] forIndexPath:indexPath];
    cell.color = [HTLColor colors][(NSUInteger) indexPath.row];
//    [cell setIsAccessibilityElement:YES];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.colorPickerDelegate colorPickerCollectionView:self didSelectColor:self.color];
}

@end

@interface HTLColorCollectionViewCell () {
    HTLColor *_color;
}

@property(nonatomic, weak) IBOutlet UILabel *colorNameLabel;
@property(nonatomic, weak) IBOutlet UIImageView *checkmarkImageView;

@end;

@implementation HTLColorCollectionViewCell
@dynamic color;

+ (NSString *)defaultIdentifier {
    return @"HTLColorCollectionViewCell";
}

- (HTLColor *)color {
    return _color;
}

- (void)setColor:(HTLColor *)color {
    _color = color;
    self.backgroundColor = _color.color;
    self.colorNameLabel.text = _color.name;
//    self.colorNameLabel.accessibilityIdentifier = _color.name;
//    self.accessibilityIdentifier = _color.name;
    self.checkmarkImageView.accessibilityIdentifier = _color.name;
    self.colorNameLabel.textColor = _color.textColor;
    self.backgroundView.accessibilityIdentifier = _color.name;
}

- (void)setSelected:(BOOL)selected {

    self.checkmarkImageView.image = selected ? [UIImage imageNamed:@"checkmark"] : nil;
}

//- (BOOL)isAccessibilityElement {
//    return YES;
//}
//
//- (UIAccessibilityTraits)accessibilityTraits {
//    return super.accessibilityTraits | UIAccessibilityTraitButton;
//}
//
//- (void)accessibilityElementDidBecomeFocused {
//    UICollectionView *collectionView = (UICollectionView *) self.superview;
//    [collectionView scrollToItemAtIndexPath:[collectionView indexPathForCell:self] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally | UICollectionViewScrollPositionCenteredVertically animated:NO];
//    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
//}

@end
