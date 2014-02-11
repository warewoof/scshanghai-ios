//
//  MenuViewController.h
//  shanghai
//
//  Created by Frank Yin on 10/22/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class MenuViewController;

@protocol WWMenuDelegate <NSObject>
-(void)refreshCatalog:(MenuViewController *)controller;
@end

@interface MenuViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,NSURLConnectionDataDelegate> {
    UITableView* tableView;
    NSString* localLastModString;
    UIAlertView* alertCheckForUpdate;
    UIAlertView* alertOptionDownload;
    NSMutableData* zipDownload;
    float catalodDownloadSize;
}

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, weak) id <WWMenuDelegate> delegate;

@end
