//
//  MapViewController.m
//  shanghai
//
//  Created by Frank Yin on 9/18/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "MapViewController.h"
#import "MapPoint.h"
#import "CustomAnnotationView.h"
#import "ChildViewController.h"
#import "DisplayFx.h"
#import "StringFx.h"
#import "DebugFx.h"
#import "XmlFx.h"
#import "DejalActivityView.h"


@interface MapViewController ()


@end

@implementation MapViewController

@synthesize mapTitle, mapView, locationManager, childItem, isSingleView, isChildView, geoChildItems;
@synthesize NEpoint, SWpoint, spanLatitude, spanLongitude, shareUrl;


- (void) loadView {
    
    
    
    /* initialize top navigation controller bar */
    self.navigationItem.title = mapTitle;
    UIBarButtonItem* backbarbutton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemAdd target:nil action:nil];
    [backbarbutton setTintColor:[UIColor darkGrayColor]];
    self.navigationItem.backBarButtonItem = backbarbutton;
    
    
    /* initialize bottom toolbar */
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.tintColor = [UIColor darkGrayColor];
    UIImage* zoomInImg = [UIImage imageNamed:@"magPlus32"];
    UIBarButtonItem* zoomIn = [[UIBarButtonItem alloc] initWithImage:zoomInImg style:UIBarButtonItemStyleBordered target:self action:@selector(zoomIn)];
    UIImage* zoomOutImg = [UIImage imageNamed:@"magMin32.png"];
    UIBarButtonItem* zoomOut = [[UIBarButtonItem alloc] initWithImage:zoomOutImg style:UIBarButtonItemStyleBordered target:self action:@selector(zoomOut)];
    UIImage* myLocImg = [UIImage imageNamed:@"myLoc32.png"];
    UIBarButtonItem* myLoc = [[UIBarButtonItem alloc] initWithImage:myLocImg style:UIBarButtonItemStyleBordered target:self action:@selector(spanMyLocation)];
    UIBarButtonItem* flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if ([geoChildItems count] == 1) {
        self.isSingleView = YES;
        self.childItem = [geoChildItems objectAtIndex:0];
    }
    
    NSArray* buttonArray;
    if (isSingleView) {
        UIBarButtonItem* shareMap = [[UIBarButtonItem alloc] initWithTitle:@"SMS" style:UIBarButtonItemStyleBordered target:self action:@selector(shareMap)];
        buttonArray = [[NSArray alloc] initWithObjects: flexibleSpaceButtonItem, zoomIn, zoomOut, myLoc, shareMap, flexibleSpaceButtonItem, nil];
        
        /* initiate Goo.gl URL Request here */
        [self shortenMapUrl];
        
    } else {
        buttonArray = [[NSArray alloc] initWithObjects: flexibleSpaceButtonItem, zoomIn, zoomOut, myLoc, flexibleSpaceButtonItem, nil];
    }
    [self setToolbarItems:buttonArray animated:YES];
    
    
    /* initialize main map view */
    self.view = [[UIView alloc] init];
    [DejalBezelActivityView removeViewAnimated:YES];
    
    mapView = [[MKMapView alloc] init];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    [self.mapView setShowsUserLocation:YES];
    
    
    
    DebugFx* debug = [[DebugFx alloc] initWithName:@"MapView Load Time"];
    [debug start];
    
    /* initialize and add map markers */
    if (isSingleView) {
        DLog(@"%@", childItem.attributeLink);
        NSArray* geoComponents = [childItem.attributeLink componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":,"]];
        CLLocationCoordinate2D newCoord = { [[geoComponents objectAtIndex:1] floatValue], [[geoComponents objectAtIndex:2] floatValue] };
        [self checkMapSpan:newCoord];
        MapPoint* mp = [[MapPoint alloc] initWithCoordinate:newCoord title:childItem.attributeName subTitle:childItem.attributeValue
                                                      child:childItem.childName
                                                     parent:childItem.parentName
                                                      color:childItem.color];
        [self.mapView addAnnotation:mp];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newCoord, 1000, 1000);
        [self.mapView setRegion:region animated:YES];
        
    } else {
        DLog(@"Map multiple addresses, %d", geoChildItems.count);
        
        double tempLong;
        double tempLat;
        for (ChildItem* cItem in geoChildItems) {
            @try {
                
                NSArray* geoComponents = [cItem.attributeLink componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":,"]];
                tempLat = [[geoComponents objectAtIndex:1] floatValue];
                tempLong = [[geoComponents objectAtIndex:2] floatValue];
                CLLocationCoordinate2D newCoord = { tempLat, tempLong };
                [self checkMapSpan:newCoord];
                
                NSString* pTitle;
                NSString* pSubTitle;
                if (isChildView) {
                    pTitle = cItem.attributeName;
                    pSubTitle = cItem.attributeValue;
                } else {
                    pTitle = cItem.childName;
                    if ([[cItem.attributeName lowercaseString] isEqualToString:@"address"]) { // since address is hidden here, it may need to be manually supplied as object of interest later
                        pSubTitle = @"";
                    } else {
                        pSubTitle = cItem.attributeName;
                    }
                    
                }
                MapPoint* mp = [[MapPoint alloc] initWithCoordinate:newCoord title:pTitle subTitle:pSubTitle
                                                              child:cItem.childName
                                                             parent:cItem.parentName
                                                              color:cItem.color];
                [self.mapView addAnnotation:mp];
            } @catch (NSException* e) {
                DLog(@"Exception at %@: %@", cItem.childName, e);
            }
            
        }
        
        
        
    }
    
    [debug stop];
    [debug stats];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = NO;
MKCoordinateRegion region;
        if (geoChildItems.count <= 1) {
            region = MKCoordinateRegionMakeWithDistance([self getCenterPoint], 1000, 1000);
        } else {
            region = MKCoordinateRegionMake([self getCenterPoint],
                                            MKCoordinateSpanMake(fabs(NEpoint.latitude - SWpoint.latitude)*1.2, fabs(NEpoint.longitude - SWpoint.longitude)*1.2));
        }
        
        
        [self.mapView setRegion:region animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.toolbarHidden = YES;
    [self.mapView setShowsUserLocation:NO];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    DLog(@"Annotation view clicked");
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    MapPoint* mapPoint = (MapPoint*)view.annotation;
    DLog(@"mapPoint info %@", mapPoint.child);
    
    
    ChildViewController* nCVC = [[ChildViewController alloc] init];
    nCVC.parentString = mapPoint.parent;
    nCVC.childName = mapPoint.child;
    nCVC.color = mapPoint.color;
    if ([mapPoint.subTitle isEqualToString:@""]) {
        nCVC.objectOfInterest = @"Address";         // since only "address" text is specifically hidden hard coding here is acceptable
    } else {
        nCVC.objectOfInterest = mapPoint.subTitle;  // this will set up the tableview to be automatically scroll to this item
    }
    nCVC.highlightObjectOfInterest = YES;
    
    [self.navigationController pushViewController:nCVC animated:YES];
    
    
}


-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    NSString* annotationId = @"PinViewAnnotation";
    
    MKPinAnnotationView* pinView = (MKPinAnnotationView*) [self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationId];
    //CustomAnnotationView* pinView = (CustomAnnotationView*) [self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationId];
    
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationId];
        //pinView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationId];
        [pinView setPinColor:MKPinAnnotationColorPurple];
        if (geoChildItems.count <= 1) {
            pinView.animatesDrop = YES;
        } else {
            pinView.animatesDrop = NO;
        }
        pinView.canShowCallout = YES;
        
        
        //UIImageView* pinIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker3off.png"]];
        //[pinIconView setFrame:CGRectMake(0, 0, 23, 30)];
        //pinView.leftCalloutAccessoryView = pinIconView;
        if (!self.isSingleView && !self.isChildView) {
            pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
    } else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    //DLog(@"didAddAnnotationViews");
    
    CGRect visibleRect = [self.mapView annotationVisibleRect];
    @try {
        for (MKAnnotationView* view in views) {
            
            if ([view isKindOfClass:[CustomAnnotationView class]]) {
                
                CGRect endFrame = view.frame;
                
                CGRect startFrame = endFrame;
                
                startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
                view.frame = startFrame;
                
                [UIView beginAnimations:@"drop" context:NULL];
                [UIView setAnimationDuration:0.3];
                
                view.frame = endFrame;
                [UIView commitAnimations];
            }
        }
    } @catch (NSException* e) {
        NSLog(@"Exception: %@", e);
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) zoomIn {
    DLog(@"Zoom In Pressed");
    @try {
        MKCoordinateRegion region = mapView.region;
        MKCoordinateSpan span;
        span.latitudeDelta = region.span.latitudeDelta / 2;
        span.longitudeDelta = region.span.longitudeDelta / 2;
        region.span = span;
        [mapView setRegion:region animated:TRUE];
    } @catch (NSException* e) {
        NSLog(@"Exception: %@",e);
    }
    
}

-(void) zoomOut {
    DLog(@"Zoom Out Pressed");
    @try {
        MKCoordinateRegion region = mapView.region;
        MKCoordinateSpan span;
        span.latitudeDelta = region.span.latitudeDelta * 2;
        span.longitudeDelta = region.span.longitudeDelta * 2;
        region.span = span;
        [mapView setRegion:region animated:TRUE];
    } @catch (NSException* e) {
        NSLog(@"Exception: %@",e);
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    DLog(@"didUpdateUserLocation");
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    DLog(@"location manager updated location");
}

-(void) spanMyLocation {
    DLog(@"Location Button Pressed");
    
    MKUserLocation* userLocation = mapView.userLocation;
    if (!userLocation.location) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:@"Location Unavailable"
                                                       message:@"Please check Settings to turn on Location Service for this app"
                                                      delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }

    CLLocationCoordinate2D withUserCenter = mapView.userLocation.location.coordinate;
    CLLocationCoordinate2D spanTo;
    

    
    if (fabs(NEpoint.latitude - withUserCenter.latitude) > fabs(SWpoint.latitude - withUserCenter.latitude)) {
        spanTo.latitude = NEpoint.latitude;
    } else {
        spanTo.latitude = SWpoint.latitude;
    }
    if (fabs(NEpoint.longitude - withUserCenter.longitude) > fabs(SWpoint.longitude - withUserCenter.longitude)) {
        spanTo.longitude = NEpoint.longitude;
    } else {
        spanTo.longitude = SWpoint.longitude;
    }
    
    
    
    MKCoordinateSpan withUserSpan = MKCoordinateSpanMake(fabs(spanTo.latitude - withUserCenter.latitude) * 1.2, fabs(spanTo.longitude - withUserCenter.longitude) * 1.2);
    
    
    withUserCenter.latitude = (withUserCenter.latitude + [self getCenterPoint].latitude) / 2;
    withUserCenter.longitude = (withUserCenter.longitude + [self getCenterPoint].longitude) / 2;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(withUserCenter, withUserSpan);
    [mapView setRegion:region animated:TRUE];
}

-(void) shareMap {
    DLog(@"Share Map Pressed, share %@", self.shareUrl);
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController* controller = [[MFMessageComposeViewController alloc] init];
        controller.body = [NSString stringWithFormat:@"%@\n%@\n%@", self.childItem.childName, self.childItem.attributeValue,self.shareUrl];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        UIAlertView* notpermitted = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support SMS. The text has been copied to your clipboard." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notpermitted show];
    }
    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            DLog(@"MessageComposeResultCancelled");
            break;
            
        case MessageComposeResultFailed:
            DLog(@"MessageComposeResultFailed");
            break;
            
        case MessageComposeResultSent:
            DLog(@"MessageComposeResultSent");
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) checkMapSpan:(CLLocationCoordinate2D) newCoordinate {
    
    if ((NEpoint.latitude == 0) && (NEpoint.longitude == 0)) {
        NEpoint = newCoordinate;
    }
    if ((SWpoint.latitude == 0) && (SWpoint.longitude == 0)) {
        SWpoint = newCoordinate;
    }
    
    if (NEpoint.latitude <= newCoordinate.latitude) {
        NEpoint.latitude = newCoordinate.latitude;
    }
    
    if (NEpoint.longitude <= newCoordinate.longitude) {
        NEpoint.longitude = newCoordinate.longitude;
    }
    
    if (SWpoint.latitude >= newCoordinate.latitude) {
        SWpoint.latitude = newCoordinate.latitude;
    }
    
    if (SWpoint.longitude >= newCoordinate.longitude) {
        SWpoint.longitude = newCoordinate.longitude;
    }
    
}

-(CLLocationCoordinate2D) getCenterPoint {
    
    CLLocationCoordinate2D centerPoint = { (NEpoint.latitude + SWpoint.latitude) / 2,
        (NEpoint.longitude + SWpoint.longitude) / 2};
    
    return centerPoint;
    
}

-(void)shortenMapUrl {
    
    self.shareUrl = [StringFx convertLinkToGoogleMapUrl:childItem.attributeLink];
    NSString* googString = @"https://www.googleapis.com/urlshortener/v1/url";
    
    DLog(@"%@",googString);
    NSURL* googUrl = [NSURL URLWithString:googString];
    
    NSMutableURLRequest* googReq = [NSMutableURLRequest requestWithURL:googUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    [googReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString* longDataString = [NSString stringWithFormat:@"{\"longUrl\": \"%@\"}",self.shareUrl];
    DLog(@"Long URL String: %@", longDataString);
    NSData* longUrlData = [longDataString dataUsingEncoding:NSUTF8StringEncoding];
    [googReq setHTTPBody:longUrlData];
    [googReq setHTTPMethod:@"POST"];
    
    NSURLConnection* connect = [[NSURLConnection alloc] initWithRequest:googReq delegate:self];
    connect = nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    DLog(@"didReceiveResponse");
    
    /* HEADer received, get last modified date and compare to local version */
    if ([[[connection currentRequest] HTTPMethod] isEqualToString:@"POST"]) {       // check head information for last mod timestamp
        DLog(@"Method is equal to POST");
        
        NSInteger statusCode = [(NSHTTPURLResponse*) response statusCode];
        DLog(@"Status code %i", statusCode);
        if (statusCode == 200) {
            goodURLResponse = YES;                          // header response is good
            googUrlData = [[NSMutableData alloc] init];     // so initialize the data array
        } else {
            goodURLResponse = NO;
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    DLog(@"didReceiveData");
    [googUrlData appendData:data];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    DLog(@"connectionDidFinishLoading");
    
    if (([googUrlData length] > 0) && goodURLResponse) {        // data exists and original header response was good
        NSError* error = nil;
        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:googUrlData options:NSJSONReadingMutableLeaves error:&error];
        if (error == nil) {                                     // data is parsed
            if ([jsonArray valueForKey:@"id"] != nil) {
                self.shareUrl = [jsonArray valueForKey:@"id"];  // extract shortened URL
            }
        } else {
            NSLog(@"Error %@", error);
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError %@", error);
}




@end
