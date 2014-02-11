//
//  SplashViewController.m
//  shanghai
//
//  Created by Frank Yin on 9/6/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "SplashViewController.h"
#import "ListViewController.h"
#import "DisplayFx.h"
#import "CatalogFx.h"
#import "DejalActivityView.h"



@implementation SplashViewController



@synthesize window;

- (void)loadView {
    DLog(@"loadView NewViewController");
    
    
    /* check for existing catalog.xml file in local directory */
    NSString* catalogPath = [CatalogFx localCatalogFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:catalogPath]) {
        DLog(@"Catalog Exists");
        
        NSDictionary* dictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:catalogPath error:nil];
        NSDate* fileDate = [dictionary objectForKey:NSFileModificationDate];
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM.dd.yyyy HH.mm.ss"];
        
        DLog(@"Catalog mod time: %@", [dateFormat stringFromDate:fileDate]);
    } else {
        DLog(@"Catalog Does Not Exist");
    }
    
    
    
    /* check server for last modified time */
    NSMutableURLRequest* modReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[CatalogFx serverUrl]]
                                                          cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                      timeoutInterval:10.0f];
    [modReq setHTTPMethod:@"HEAD"];
    NSURLConnection* connect = [[NSURLConnection alloc] initWithRequest:modReq delegate:self];
    connect = nil;
    

    
    self.view = [[UIView alloc] init];
    topView = self.view;
	self.view.backgroundColor = [DisplayFx colorWithHexString:@"ffffff"];
    
    [self launchCatalogBusyState:NO];
    
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    DLog(@"didReceiveResponse");
    
    
    /* HEADer received, get last modified date and compare to local version */
    if ([[[connection currentRequest] HTTPMethod] isEqualToString:@"HEAD"]) {               // check head information for last mod timestamp
        
        NSDictionary* returnDict = [(NSHTTPURLResponse*) response allHeaderFields];         // get status code to ensure file exists (HTTP 200)
        
        NSString* contentLength = [returnDict objectForKey:@"Content-Length"];
        DLog(@"Content-Length %@", contentLength);
        catalodDownloadSize = [contentLength floatValue];
        
        NSInteger statusCode = [(NSHTTPURLResponse*) response statusCode];
        DLog(@"Status code %i", statusCode);
        

        if (statusCode == 200) {
            NSString* serverLastMod = [returnDict objectForKey:@"Last-Modified"];                 // get last mod string from header
           
            if ([CatalogFx localCatalogShouldBeUpdated:serverLastMod ifFileNotFound:NO]) {
                NSString* fileSizeString = [CatalogFx convertFileSizeStringFromHeader:contentLength];
     
                UIAlertView* downloadOption = [[UIAlertView alloc] initWithTitle:@"Update?"
                                                                         message:[NSString stringWithFormat:@"An updated catalog is available, would you like to download? \nTotal size: %@", fileSizeString]
                                                                        delegate:self
                                                               cancelButtonTitle:@"NO"
                                                               otherButtonTitles:@"YES", nil];
                [downloadOption show];
            }
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    

    if (buttonIndex == 1) {  // YES clicked
        DLog(@"Initiate zip file download");
        
        NSURLRequest* downloadFile = [NSURLRequest requestWithURL:[NSURL URLWithString:[CatalogFx serverUrl]]
                                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                  timeoutInterval:60.0f];
        
        zipDownload = [[NSMutableData alloc] init];
        
        NSURLConnection* connect = [[NSURLConnection alloc] initWithRequest:downloadFile delegate:self];
        connect = nil;
        

        [self launchCatalogBusyState:YES];  // relaunch in order to show dejal status window
        
        
    } else {
        DLog(@"User declined to download");
    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [zipDownload appendData:data];
    float progress = ((float)[zipDownload length] / catalodDownloadSize) * 100;
    [DejalBezelActivityView activityViewForView:nLVC.view withLabel:[NSString stringWithFormat:@"%0.0f%% Complete", progress] width:0 animate:NO ];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    DLog(@"connectionDidFinishLoading");
    
    NSString* catalogPath = [CatalogFx localZipFilePath];
    
    if ([[[connection currentRequest] HTTPMethod] isEqualToString:@"HEAD"]) {
        return;
    }
    
    if ([zipDownload length] >= 1) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:catalogPath]) {
            DLog(@"Creating Zip file path: %@", catalogPath);
            [[NSFileManager defaultManager] createFileAtPath:catalogPath contents:nil attributes:nil];
            NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingAtPath:catalogPath];
            [fileHandle writeData:zipDownload];
            [CatalogFx unzipToDocumentsDirectory];

            
            [DejalBezelActivityView removeViewAnimated:NO];
            [DejalBezelActivityView activityViewForView:nLVC.view withLabel:@"Download Complete" width:0 animate:NO];
            [self performSelector:@selector(delayDownloadCompleteNotification) withObject:nil afterDelay:1];
            //[self launchCatalogBusyState:NO];

            
        } else {       // this case should not come up
            DLog(@"Zip file exists");
            NSError* error = nil;
            if (![[NSFileManager defaultManager] removeItemAtPath:catalogPath error:&error]) {
                DLog(@"Error removing file: %@", error);
            } else {
                DLog(@"Zip file deleted");
            }
        }
    } else {
        UIAlertView* errorDownload = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"Please check the internet connection or try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [errorDownload show];
        DLog(@"Downloaded file size is 0");
    }
    
}

-(void)delayDownloadCompleteNotification{
    //[DejalBezelActivityView activityViewForView:nLVC.view withLabel:@"Download Complete"];
    //[self performSelector:@selector(delayDownloadCompleteNotification) withObject:nil afterDelay:1];
    [self launchCatalogBusyState:NO];
}

-(void)launchCatalogBusyState:(BOOL)busy {
    
    nLVC = [[ListViewController alloc] init];
    nLVC.parentString = rootCatalogParent;
    nLVC.sectionString = rootCatalogChild;
    nLVC.enableMenuButton = YES;

    [self.navigationController pushViewController:nLVC animated:YES];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:nLVC];
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setRootViewController:navController];
    [window makeKeyAndVisible];
    /*
    if (busy) {  // busy because app is currently downloading new catalog
        [DejalBezelActivityView activityViewForView:nLVC.view withLabel:@"Downloading..."];
        [self.navigationController popToRootViewControllerAnimated:NO];     // without animation this gives the appearance of letting the Dejal indicator to show up
    } else {
        [DejalBezelActivityView removeViewAnimated:YES];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
     */
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    DLog(@"didFailWithError");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
