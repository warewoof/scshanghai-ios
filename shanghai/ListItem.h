//
//  ListObject.h
//  shanghai
//
//  Created by Frank Yin on 9/16/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListItem : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic) NSString* parentName;
@property (nonatomic) NSString* color;
@property (nonatomic) BOOL isChild;
@property (nonatomic) BOOL isCalendar;


-(id) initWithVars:(NSString*)iName parent:(NSString*)iParent color:(NSString*)iColor;

-(id) initWithVars:(NSString*)iName parent:(NSString*)iParent color:(NSString*)iColor isChild:(BOOL)iChild;

-(id) initWithVars:(NSString*)iName parent:(NSString*)iParent color:(NSString*)iColor isCalendar:(BOOL)iCalendar;
    
@end
