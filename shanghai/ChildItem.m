//
//  ChildItem.m
//  shanghai
//
//  Created by Frank Yin on 9/16/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "ChildItem.h"
#import "StringFx.h"
#import "CatalogFx.h"


@implementation ChildItem

@synthesize attributeName;
@synthesize attributeValue;
@synthesize attributeLink;
@synthesize attributeOptions;
@synthesize parentName;
@synthesize childName;
@synthesize isGeoLink, isTelLink, isWebLink, isEmailLink, isImage;
@synthesize color;
@synthesize imagePath;


-(id)initWithVars:(NSString*)iChild parent:(NSString*)iParent color:(NSString*)iColor name:(NSString*)iName value:(NSString*)iValue link:(NSString*)iLink options:(NSString*)iOptions {
    
    self.childName = iChild;
    self.parentName = iParent;
    self.color = iColor;
    self.attributeName = iName;
    self.attributeValue = [StringFx unescapeXml:iValue];
    self.attributeLink = iLink;
    self.attributeOptions = iOptions;

    //NSLog(@"Initializing %@ child with link %@", iName, iLink);
    NSString* linkIgnoreCase = [iLink lowercaseString];
    if ([linkIgnoreCase hasPrefix:@"http://"]) {
        self.isWebLink = YES;
    } else if ([linkIgnoreCase hasPrefix:@"www."]) {
        self.isWebLink = YES;
        self.attributeLink = [NSString stringWithFormat:@"http://%@", iLink];
    } else if ([linkIgnoreCase hasPrefix:@"geo:"]) {
        self.isGeoLink = YES;
        self.attributeLink = linkIgnoreCase;
        //[self initGeo:linkIgnoreCase];
    } else if ([linkIgnoreCase hasPrefix:@"tel:"]) {
        self.isTelLink = YES;
        self.attributeLink = linkIgnoreCase;
    } else if ([StringFx stringIsValidEmail:self.attributeLink]) {
        self.isEmailLink = YES;
    }
    
    linkIgnoreCase = [self.attributeName lowercaseString];
    if ([linkIgnoreCase isEqualToString:@"(image)"]) {
        isImage = YES;
        
        NSString* tmpPath = [CatalogFx localDataDirectory];
        tmpPath = [tmpPath stringByAppendingPathComponent:[StringFx regexFilePath:[self.parentName lowercaseString]]];
        tmpPath = [tmpPath stringByAppendingPathComponent:[StringFx regexFilePath:[self.childName lowercaseString]]];
        tmpPath = [tmpPath stringByAppendingPathComponent:self.attributeLink];
        
        self.imagePath = tmpPath;
        DLog(@"Constructed image path %@", self.imagePath);
    }
    
    return self;
}

-(void) initGeo:(NSString*) geoString {
    NSArray* geoComponents = [geoString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":,"]];
    DLog(@"%@", geoComponents);
}

@end
