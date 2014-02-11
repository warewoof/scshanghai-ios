//
//  ChildViewAlert.m
//  shanghai
//
//  Created by Frank Yin on 10/1/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//
#import "ChildViewAlert.h"
#import "ChildViewController.h"
#import "TaxiCardViewController.h"
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>


@implementation ChildViewAlert

@synthesize childItem, childViewController;


- (id)initWithChild:(ChildItem*)cItem childViewController:(ChildViewController*) controller {
    

    if (self) {
        self.childItem = cItem;
        self.childViewController = controller;
    }
    self = [super initWithTitle:@"" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send SMS", @"Taxi Card", @"Copy to Clipboard", nil];
    
    return self;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    DLog(@"Alert Clicked, button index %d", buttonIndex);
    if (buttonIndex == 1) { //send SMS
        DLog(@"Send SMS clicked");
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController* controller = [[MFMessageComposeViewController alloc] init];
            controller.body = [NSString stringWithFormat:@"%@\n%@", self.childItem.childName, self.childItem.attributeValue];
            controller.messageComposeDelegate = childViewController;
            [childViewController presentViewController:controller animated:YES completion:nil];
        } else {
            UIAlertView* notpermitted = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support SMS. The text has been copied to your clipboard." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [notpermitted show];
        }
        
    } else if (buttonIndex == 2) {
        DLog(@"Write the taxi card function here....");
        
        TaxiCardViewController* nTCVC = [[TaxiCardViewController alloc] init];
        nTCVC.showTitle = childItem.attributeName;
        nTCVC.showText = childItem.attributeValue;
        
        [childViewController.navigationController pushViewController:nTCVC animated:YES];
        
    } else if (buttonIndex == 3) {
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:childItem.attributeValue];
        
        DLog(@"Value Copied");
        
        
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    DLog(@"Message Compose did finish with result");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
