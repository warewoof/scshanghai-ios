//
//  ListViewAlert.h
//  shanghai
//
//  Created by Frank Yin on 10/29/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListItem.h"
#import "ListViewController.h"

@interface ListViewAlert : UIAlertView <UIAlertViewDelegate> {
    NSArray* buttonFunction;
    UIAlertView* searchAlertView;
}

@property ListItem* listItem;
@property ListViewController* listViewController;

-(id)initWithListItem:(ListItem*)lItem withViewController:(ListViewController*)lvc;

@end
