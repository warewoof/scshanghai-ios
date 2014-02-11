//
//  EventItem.m
//  shanghai
//
//  Created by Frank Yin on 10/17/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "EventItem.h"

@implementation EventItem

@synthesize calendarName, parentName, color, eventName, dateText, dateStart, dateEnd;
@synthesize textTitle, textDescription, textSmallPrint, locationText, locationLink, linkText, linkLink;

-(id)initiWithVars:(NSString*)iCalendarName parent:(NSString*)iParentName color:(NSString*)iColor {
    self.calendarName = iCalendarName;
    self.parentName = iParentName;
    self.color = iColor;
    return self;    
}

-(BOOL)linkProvided {
    if ([self.locationText length] > 0) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)locationProvided {
    if ([self.linkText length] > 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
