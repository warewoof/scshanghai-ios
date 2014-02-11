//
//  SplashViewController.h
//  shanghai
//
//  Created by Frank Yin on 9/6/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface SplashViewController : UIViewController <NSURLConnectionDataDelegate, UIAlertViewDelegate> {
    UIView* topView;
    ListViewController* nLVC;
    NSMutableData* zipDownload;
    float catalodDownloadSize;
}



@property UIWindow* window;


@end
