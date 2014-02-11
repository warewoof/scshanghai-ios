//
//  ChildViewController.h
//  shanghai
//
//  Created by Frank Yin on 9/14/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>



@interface ChildViewController : UIViewController <UITableViewDelegate,
                                                   UITableViewDataSource,
                                                   UIGestureRecognizerDelegate,
                                                   MFMessageComposeViewControllerDelegate,
                                                   MFMailComposeViewControllerDelegate,
                                                   UINavigationControllerDelegate> {
    UITableView* tableView;
    NSMutableArray* childValues;
    NSInteger scrollToIndex;
}

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic) BOOL disableBack;
@property (nonatomic) BOOL disableSearch;
@property (nonatomic) BOOL disableShare;
@property (nonatomic) BOOL disableMap;
@property (nonatomic) NSString* childName;
@property (nonatomic) NSString* parentString;
@property (nonatomic) NSString* color;
@property (nonatomic) NSString* objectOfInterest;
@property (nonatomic) BOOL highlightObjectOfInterest;

@end
