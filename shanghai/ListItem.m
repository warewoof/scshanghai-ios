//
//  ListObject.m
//  shanghai
//
//  Created by Frank Yin on 9/16/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

@synthesize name;
@synthesize parentName;
@synthesize color;
@synthesize isChild, isCalendar;


-(id) initWithVars:(NSString*)iName parent:(NSString*)iParent color:(NSString*)iColor {
    self.name = iName;
    self.parentName = iParent;
    self.color = iColor;
    
    return self;
}


-(id) initWithVars:(NSString*)iName parent:(NSString*)iParent color:(NSString*)iColor isChild:(BOOL)iChild {
    self.name = iName;
    self.parentName = iParent;
    self.color = iColor;
    self.isChild = iChild;
    self.isCalendar = NO;
    
    return self;
}

-(id) initWithVars:(NSString*)iName parent:(NSString*)iParent color:(NSString*)iColor isCalendar:(BOOL)iCalendar {
    self.name = iName;
    self.parentName = iParent;
    self.color = iColor;
    self.isCalendar = isCalendar;
    self.isChild = NO;
    
    return self;
}


@end
