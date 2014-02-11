//
//  ChildViewAlert.h
//  shanghai
//
//  Created by Frank Yin on 10/1/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import "ChildItem.h"
#import "ChildViewController.h"


@interface ChildViewAlert : UIAlertView <UIAlertViewDelegate, MFMessageComposeViewControllerDelegate>

//@property (nonatomic, weak) id <ChildViewControllerDelegate> delegate;
@property ChildItem* childItem;
@property ChildViewController* childViewController;


-(id)initWithChild:(ChildItem*)cItem childViewController:(ChildViewController*) controller;

@end
