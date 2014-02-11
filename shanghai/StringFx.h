//
//  StringFx.h
//  shanghai
//
//  Created by Frank Yin on 9/16/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringFx : NSObject

+(NSString*)escapeXml:(NSString*)string;
+(NSString*)unescapeXml:(NSString*)string;
+(BOOL)stringIsValidEmail:(NSString*)checkString;
+(NSString*)regexFilePath:(NSString*)checkString;
+(NSString*)convertLinkToGoogleMapUrl:(NSString*)childLink;
+(NSDate*)convertStringToDate:(NSString*)dateString format:(NSString*)format;
@end
