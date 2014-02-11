//
//  displayFx.m
//  shanghai
//
//  Created by Frank Yin on 9/6/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "DisplayFx.h"

@implementation DisplayFx


+(void) customizeAppearance {
    UIImage* img1 = [[UIImage imageNamed:@"backbutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 6)];
    UIImage* img2 = [[UIImage imageNamed:@"backbutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 6)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:img1 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:img2 forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:img1 forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:img2 forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
}

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*)imageWithImage:(UIImage*)image scaledAspectToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    
    float aspectRatio;
    if (image.size.width > image.size.height) {     // scale constraint width
        aspectRatio = image.size.width / image.size.height;
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.width / aspectRatio)];
    } else {    // scale constraint height
        aspectRatio = image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, newSize.height / aspectRatio, newSize.height)];
    }
    

    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(CGSize)image:(UIImage *)image fitToSize:(CGSize)newSize {
    
    float aspectRatio;
    float fitWidth;
    float fitHeight;
    if (image.size.width > image.size.height) {     // scale constraint width
        aspectRatio = image.size.width / image.size.height;
        fitWidth = newSize.width;
        fitHeight = newSize.width / aspectRatio;
    } else {    // scale constraint height
        aspectRatio = image.size.height / image.size.width;
        fitWidth = newSize.height / aspectRatio;
        fitHeight = newSize.height;
    }
    
    return CGSizeMake(fitWidth, fitHeight);

}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end
