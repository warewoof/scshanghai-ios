//
//  MapPoint.h
//  shanghai
//
//  Created by Frank Yin on 9/18/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapPoint : NSObject<MKAnnotation> {
    NSString* title;
    NSString* subTitle;
    CLLocationCoordinate2D coordinate;
    NSString* child;
    NSString* parent;
    NSString* color;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subTitle;
@property (nonatomic, copy) NSString* child;
@property (nonatomic, copy) NSString* parent;
@property (nonatomic, copy) NSString* color;

-(id) initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString*)t subTitle:(NSString*) st;
-(id) initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString*)t subTitle:(NSString*) st child:(NSString*) ch parent:(NSString*) pr color:(NSString*) co;


@end
