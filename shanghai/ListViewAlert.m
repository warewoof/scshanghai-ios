//
//  ListViewAlert.m
//  shanghai
//
//  Created by Frank Yin on 10/29/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#define cancelButton [NSNumber numberWithInteger:0]
#define searchButton [NSNumber numberWithInteger:1]
#define homeButton [NSNumber numberWithInteger:2]

#import "ListViewAlert.h"




@implementation ListViewAlert

@synthesize listItem, listViewController;

-(id)initWithListItem:(ListItem*)lItem withViewController:(ListViewController*)lvc;
{
    
    if (self) {
        self.listItem = lItem;
        self.listViewController = lvc;
    }
    
    NSString* messageTitle;
    NSArray* buttonText;
    if ([lItem.parentName isEqualToString:@"Shanghai"]) {   // top level menu already
        if (lItem.isChild || lItem.isCalendar) {
            return nil;
        } else {
            buttonText = [[NSArray alloc] initWithObjects:@"Search", nil];
            buttonFunction  = [[NSArray alloc] initWithObjects:cancelButton, searchButton, nil];
            messageTitle = lItem.name;
        }
        
    } else {
        if (lItem.isChild) {
            buttonText = [[NSArray alloc] initWithObjects:@"Home", nil];
            buttonFunction  = [[NSArray alloc] initWithObjects:cancelButton, homeButton, nil];
            messageTitle = @"Return to home menu?";
        } else {
            buttonText = [[NSArray alloc] initWithObjects:@"Search section", @"Back to home menu", nil];
            buttonFunction  = [[NSArray alloc] initWithObjects:cancelButton, searchButton, homeButton, nil];
            messageTitle = lItem.name;
        }
        
    }
    
    self = [super initWithTitle:messageTitle message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    for (NSString* title in buttonText) {
        [self addButtonWithTitle:title];
    }
    
    
    return self;
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == searchAlertView) {
        DLog(@"Search View Alert Clicked, button index %d", buttonIndex);
        
        
    } else {
        
        
        DLog(@"List View Alert Clicked, button index %d", buttonIndex);
        if ([buttonFunction objectAtIndex:buttonIndex] == searchButton) {
            DLog(@"Search clicked");
            UIAlertView* tempAlert = [[UIAlertView alloc] initWithTitle:@"Search" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Find", nil];
            // cant set delagate to self since this is 
            [tempAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [tempAlert show];
            
        } else if ([buttonFunction objectAtIndex:buttonIndex] == homeButton) {
            
            DLog(@"Home clicked");
            [self.listViewController.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
    
}


@end
