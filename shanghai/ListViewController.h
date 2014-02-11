//
//  ListViewController.h
//  shanghai
//
//  Created by Frank Yin on 9/6/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"


@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, WWMenuDelegate> {
    UITableView* tableView;
    NSArray* catalog;
    UIActivityIndicatorView* spinner;

}

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic) BOOL disableBack;
@property (nonatomic) BOOL disableSearch;
@property (nonatomic) BOOL disableShare;
@property (nonatomic) BOOL disableMap;
@property (nonatomic) BOOL enableMenuButton;
@property (nonatomic) NSString* sectionString;
@property (nonatomic) NSString* parentString;
@property (nonatomic) NSInteger* color;

@end
