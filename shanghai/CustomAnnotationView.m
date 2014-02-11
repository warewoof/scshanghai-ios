//
//  CustomAnnotationView.m
//  shanghai
//
//  Created by Frank Yin on 9/19/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self != nil) {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(60.0, 85.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(-5, -5);

    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"marker40.png"] drawInRect:CGRectMake(13.5, 18, 27, 36)];
    //[UIImage imageNamed:@"marker3off.png"];
}



@end
