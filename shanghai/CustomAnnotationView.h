//
//  CustomAnnotationView.h
//  shanghai
//
//  Created by Frank Yin on 9/19/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomAnnotationView : MKAnnotationView

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
-(void)drawRect:(CGRect)rect;

@end
