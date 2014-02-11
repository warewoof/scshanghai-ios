//
//  XmlFx.h
//  shanghai
//
//  Created by Frank Yin on 9/14/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RXMLElement.h"

@interface XmlFx : NSObject

+(NSArray*) findList:(NSString*)section parent:(NSString*)parent;
+(NSArray*) findChild:(NSString*)child parent:(NSString*)parent color:(NSString*)color;
+(NSArray*) findCalendar:(NSString*)child parent:(NSString*)parent color:(NSString*)color linkPath:(NSString*)path;
+(NSArray*) findListGeo:(NSString*)section parent:(NSString*)parent;
+(BOOL) isChild:(NSString*)child parent:(NSString*) parent;

@end
