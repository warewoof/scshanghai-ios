//
//  displayFx.h
//  shanghai
//
//  Created by Frank Yin on 9/6/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayFx : NSObject

+(void) customizeAppearance;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+(UIImage*)imageWithImage:(UIImage*)image scaledAspectToSize:(CGSize)newSize;
+(CGSize)image:(UIImage*)image fitToSize:(CGSize)newSize;
@end
