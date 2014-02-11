//
//  MapViewController.h
//  shanghai
//
//  Created by Frank Yin on 9/18/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "ChildItem.h"


@interface MapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,NSURLConnectionDataDelegate,MFMessageComposeViewControllerDelegate> {
    MKMapView* mapView;
    CLLocationManager* locationManager;
    NSMutableData* googUrlData;
    BOOL goodURLResponse;
}

@property (nonatomic) NSString* mapTitle;
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic) ChildItem* childItem;
@property (nonatomic) BOOL isSingleView;
@property (nonatomic) BOOL isChildView;
@property (nonatomic) NSArray* geoChildItems;
@property (nonatomic) CLLocationCoordinate2D NEpoint;
@property (nonatomic) CLLocationCoordinate2D SWpoint;
@property (nonatomic) double spanLatitude;
@property (nonatomic) double spanLongitude;
@property (nonatomic) NSString* shareUrl;



@end
