//
//  MapPoint.m
//  shanghai
//
//  Created by Frank Yin on 9/18/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint

@synthesize coordinate, title, subTitle;
@synthesize child, parent, color;

-(id) initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString*)t subTitle:(NSString*) st {
    coordinate = c;
    title = t;
    subTitle = st;
    
    return self;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString*)t subTitle:(NSString*) st child:(NSString*) ch parent:(NSString*) pr color:(NSString*) co {
    
    child = ch;
    parent = pr;
    color = co;
    coordinate = c;
    title = t;
    subTitle = st;
    
    return self;
    
}

-(NSString*) title {
    return title;
}

-(NSString*) subtitle {
    return subTitle;
}
@end
