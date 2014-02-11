//
//  ChildItem.h
//  shanghai
//
//  Created by Frank Yin on 9/16/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildItem : NSObject

@property (nonatomic) NSString* attributeName;
@property (nonatomic) NSString* attributeValue;
@property (nonatomic) NSString* attributeLink;
@property (nonatomic) NSString* attributeOptions;
@property (nonatomic) NSString* parentName;
@property (nonatomic) NSString* childName;
@property (nonatomic) NSString* color;
@property (nonatomic) BOOL isGeoLink;
@property (nonatomic) BOOL isTelLink;
@property (nonatomic) BOOL isWebLink;
@property (nonatomic) BOOL isEmailLink;
@property (nonatomic) BOOL isImage;
@property (nonatomic) NSString* imagePath;

-(id)initWithVars:(NSString*)iChild parent:(NSString*)iParent color:(NSString*)iColor name:(NSString*)iName value:(NSString*)iValue link:(NSString*)iLink options:(NSString*)iOptions;

@end
