//
// Created by Maxim Pervushin on 03/02/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

#import "UIColor+HTLHelpers.h"


@implementation UIColor (HTLHelpers)

+ (NSString *)hexStringFromRGBColor:(UIColor *)color {
    NSString *hexColor = nil;

    // This method only works for RGB colors.
    if (color
            &&
            CGColorGetNumberOfComponents(color.CGColor) == 4) {
        // Get the red, green and blue components
        const CGFloat *components = CGColorGetComponents(color.CGColor);

        // These components range from [0.0, 1.0] and need to be converted to [0, 255]
        CGFloat red, green, blue;
        red = roundf(components[0] * 255.0);
        green = roundf(components[1] * 255.0);
        blue = roundf(components[2] * 255.0);

        // Convert with %02x (use 02 to always get two chars)
        hexColor = [[[NSString alloc] initWithFormat:@"%02x%02x%02x", (int) red, (int) green, (int) blue] uppercaseString];
    }

    return hexColor;
}

@end