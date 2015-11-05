//
// Created by Maxim Pervushin on 02/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLColorPickerTableView.h"
#import "HTLColor.h"


@interface HTLColorPickerTableView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HTLColorPickerTableView
@dynamic color;

- (UIColor *)color {
    NSIndexPath *selectedIndexPath = [self indexPathForSelectedRow];
    if (!selectedIndexPath) {
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return self;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[HTLColor colors] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTLColorTableViewCell *cell = (HTLColorTableViewCell *) [tableView dequeueReusableCellWithIdentifier:[HTLColorTableViewCell defaultIdentifier] forIndexPath:indexPath];
    cell.color = [HTLColor colors][(NSUInteger) indexPath.row];
    return cell;
}

@end

@interface HTLColorTableViewCell () {
    HTLColor *_color;
}

@property(nonatomic, weak) IBOutlet UILabel *colorNameLabel;
@property(nonatomic, weak) IBOutlet UIImageView *checkmarkImageView;

@end;

@implementation HTLColorTableViewCell
@dynamic color;

+ (NSString *)defaultIdentifier {
    return @"HTLColorTableViewCell";
}

- (HTLColor *)color {
    return _color;
}

- (void)setColor:(HTLColor *)color {
    _color = color;
    self.backgroundColor = _color.color;
    self.colorNameLabel.text = _color.name;
    self.colorNameLabel.textColor = _color.textColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.checkmarkImageView.image = selected ? [UIImage imageNamed:@"checkmark"] : nil;
}

@end
