//
//  StringFx.m
//  shanghai
//
//  Created by Frank Yin on 9/16/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "StringFx.h"

@implementation StringFx

+(NSString*)escapeXml:(NSString*)string {

    //DLog(@"escaping %@", string);

    NSString* newString;
    newString = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];

    
    //DLog(@"escaped: %@", newString);
    
    return newString;
}

+(NSString*)unescapeXml:(NSString*)string {
    
    //DLog(@"escaping %@", string);
    
    NSString* newString;
    newString = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    newString = [newString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
    //DLog(@"escaped: %@", newString);
    
    return newString;
}

+(BOOL)stringIsValidEmail:(NSString*)checkString {
    BOOL strictFilter = NO;
    NSString* strictFilterString = @"[A-Z0-9a-z.%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString* laxFilterString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString* emailRegex = strictFilter ? strictFilterString : laxFilterString;
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(NSString*)regexFilePath:(NSString*)checkString {
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"[^A-Za-z0-9]" options:0 error:nil];
    return [regex stringByReplacingMatchesInString:checkString options:0 range:NSMakeRange(0, checkString.length) withTemplate:@"$1"];
}

+(NSString*)convertLinkToGoogleMapUrl:(NSString*)childLink {
    NSString* gMapUrl = @"http://ditu.google.cn/maps?q=";
    
    gMapUrl = [gMapUrl stringByAppendingString:[childLink stringByReplacingOccurrencesOfString:@"geo:" withString:@""]];
    gMapUrl = [gMapUrl stringByAppendingString:@"&z=14"];
    
    return gMapUrl;
    
}

+(NSDate*)convertStringToDate:(NSString*)dateString format:(NSString*)format {

    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = format;
    //dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    //dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    return [dateFormat dateFromString:dateString];
}

@end
