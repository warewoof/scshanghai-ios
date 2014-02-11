//
//  CalendarViewController.h
//  shanghai
//
//  Created by Frank Yin on 10/16/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface CalendarViewController : UIViewController <UITableViewDelegate,
                                                      UITableViewDataSource,
                                                      UIGestureRecognizerDelegate,
                                                      UINavigationControllerDelegate> {
    UITableView* tableView;
    NSMutableArray* calendarValues;
    NSMutableArray* eventHeights;
                                                          
                                                          
}

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic) BOOL disableBack;
@property (nonatomic) BOOL disableSearch;
@property (nonatomic) BOOL disableShare;
@property (nonatomic) BOOL disableMap;
@property (nonatomic) NSString* childName;
@property (nonatomic) NSString* parentString;
@property (nonatomic) NSString* color;


@end
