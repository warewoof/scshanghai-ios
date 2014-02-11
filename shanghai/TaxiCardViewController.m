//
//  TaxiCardViewController.m
//  shanghai
//
//  Created by Frank Yin on 10/1/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "TaxiCardViewController.h"
#import "DisplayFx.h"

@interface TaxiCardViewController ()

@end

@implementation TaxiCardViewController

@synthesize showTitle, showText;

-(void)loadView {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize maxLabelSize = CGSizeMake(screenRect.size.width, 10000);
    CGSize expectedLabelSize = [showText sizeWithFont:[UIFont boldSystemFontOfSize:32.0] constrainedToSize:maxLabelSize lineBreakMode:NSLineBreakByWordWrapping];

    
    self.view = [[UIView alloc] init];
    
    if (expectedLabelSize.height > screenRect.size.height) {
        UITextView* bigText = [[UITextView alloc] init];;
        bigText.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        bigText.backgroundColor = [UIColor whiteColor];
        bigText.text = showText;
        bigText.font = [UIFont boldSystemFontOfSize:32.0];
        bigText.textColor = [DisplayFx colorWithHexString:@"111111"];
        bigText.textAlignment = NSTextAlignmentLeft;
        [bigText setEditable:NO];
        [self.view addSubview:bigText];
        

    } else {
        
        UILabel* textHolder = [[UILabel alloc] init];
        textHolder.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        textHolder.textAlignment = NSTextAlignmentCenter;
        [textHolder setNumberOfLines:0];
        textHolder.lineBreakMode = NSLineBreakByWordWrapping;
        textHolder.text = showText;
        textHolder.font = [UIFont boldSystemFontOfSize:32.0];
        textHolder.textColor = [DisplayFx colorWithHexString:@"111111"];
        [self.view addSubview:textHolder];
    }

    
        
    self.navigationItem.title = showTitle;

}


@end
