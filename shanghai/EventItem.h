//
//  EventItem.h
//  shanghai
//
//  Created by Frank Yin on 10/17/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventItem : NSObject

@property (nonatomic) NSString* calendarName;
@property (nonatomic) NSString* parentName;
@property (nonatomic) NSString* color;


@property (nonatomic) NSString* eventName;

@property (nonatomic) NSString* dateText;
@property (nonatomic) NSString* dateStart;
@property (nonatomic) NSString* dateEnd;

@property (nonatomic) NSString* textTitle;
@property (nonatomic) NSString* textDescription;
@property (nonatomic) NSString* textSmallPrint;

@property (nonatomic) NSString* locationText;
@property (nonatomic) NSString* locationLink;


@property (nonatomic) NSString* linkText;
@property (nonatomic) NSString* linkLink;


-(id)initiWithVars:(NSString*)iCalendarName parent:(NSString*)iParentName color:(NSString*)iColor;
-(BOOL)locationProvided;
-(BOOL)linkProvided;

@end
