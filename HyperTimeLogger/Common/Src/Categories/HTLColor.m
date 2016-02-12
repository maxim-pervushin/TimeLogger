//
// Created by Maxim Pervushin on 05/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLColor.h"

@implementation HTLColor
@dynamic textColor;
@dynamic identifier;

+ (NSArray *)colors {
    return @[
            [HTLColor colorWithColor:[UIColor paperColorRed] name:@"Red"],
            [HTLColor colorWithColor:[UIColor paperColorPink] name:@"Pink"],
            [HTLColor colorWithColor:[UIColor paperColorPurple] name:@"Purple"],
            [HTLColor colorWithColor:[UIColor paperColorDeepPurple] name:@"Deep Purple"],
            [HTLColor colorWithColor:[UIColor paperColorIndigo] name:@"Indigo"],
            [HTLColor colorWithColor:[UIColor paperColorBlue] name:@"Blue"],
            [HTLColor colorWithColor:[UIColor paperColorLightBlue] name:@"Light Blue"],
            [HTLColor colorWithColor:[UIColor paperColorCyan] name:@"Cyan"],
            [HTLColor colorWithColor:[UIColor paperColorTeal] name:@"Teal"],
            [HTLColor colorWithColor:[UIColor paperColorGreen] name:@"Green"],
            [HTLColor colorWithColor:[UIColor paperColorLightGreen] name:@"Light Green"],
            [HTLColor colorWithColor:[UIColor paperColorLime] name:@"Lime"],
            [HTLColor colorWithColor:[UIColor paperColorYellow] name:@"Yellow"],
            [HTLColor colorWithColor:[UIColor paperColorAmber] name:@"Amber"],
            [HTLColor colorWithColor:[UIColor paperColorOrange] name:@"Orange"],
            [HTLColor colorWithColor:[UIColor paperColorDeepOrange] name:@"Deep Orange"],
            [HTLColor colorWithColor:[UIColor paperColorBrown] name:@"Brown"],
            [HTLColor colorWithColor:[UIColor paperColorGray] name:@"Gray"],
            [HTLColor colorWithColor:[UIColor paperColorBlueGray] name:@"BlueGray"],
    ];
}

+ (instancetype)colorWithColor:(UIColor *)color name:(NSString *)name {
    HTLColor *instance = [HTLColor new];
    instance.color = color;
    instance.name = name;
    return instance;
}

- (UIColor *)textColor {
    return [UIColor isColorDark:self.color] ? [UIColor lightTextColor] : [UIColor darkTextColor];
}

- (NSString *)identifier {
    return [UIColor hexStringFromRGBColor:self.color];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToColor:other];
}

- (BOOL)isEqualToColor:(HTLColor *)color {
    if (self == color)
        return YES;
    if (color == nil)
        return NO;
    if (self.color != color.color && ![self.color isEqual:color.color])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return [self.color hash];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    HTLColor *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.color = self.color;
        copy.name = self.name;
    }

    return copy;
}

#pragma mark - description

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.color=%@", self.color];
    [description appendFormat:@", self.name=%@", self.name];
    [description appendString:@">"];
    return description;
}

@end