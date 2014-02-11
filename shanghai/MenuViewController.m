//
//  MenuViewController.m
//  shanghai
//
//  Created by Frank Yin on 10/22/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//


#define CATALOG_SECTION 0
#define ABOUT_SECTION 1
#define NO_BUTTON 0
#define YES_BUTTON 1
#define NEVER_UPDATED_STRING @"Never"

#import "MenuViewController.h"
#import "ChildViewController.h"
#import "CatalogFx.h"
#import "DejalActivityView.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize tableView;
@synthesize delegate;

-(void)loadView {
    [super loadView];
    
    self.view = [[UIView alloc] init];
    
    self.navigationItem.title = @"Menu";
    
    NSString* catalogPath = [CatalogFx localCatalogFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:catalogPath]) {
        NSLog(@"Catalog Exists");
        
        NSDictionary* dictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:catalogPath error:nil];
        NSDate* fileDate = [dictionary objectForKey:NSFileModificationDate];
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
        dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        
        localLastModString = [dateFormat stringFromDate:fileDate];
        NSLog(@"Catalog mod time: %@", localLastModString);
    } else {
        localLastModString = NEVER_UPDATED_STRING;
        NSLog(@"Catalog Does Not Exist");
    }
    
    tableView = [[UITableView alloc] initWithFrame:self.view.window.frame style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case CATALOG_SECTION:
            return 1;
            break;
            
        case ABOUT_SECTION:
            return 1;
            break;
        default:
            break;
    }
    return 0;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case CATALOG_SECTION:
            return 45;
            break;
            
        case ABOUT_SECTION:
            return 45;
            break;
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case CATALOG_SECTION:
            return 45;
            break;
            
        case ABOUT_SECTION:
            return 0;
            break;
        default:
            break;
    }
    return 0;
    
    
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case CATALOG_SECTION:
            return @"Catalog Last Updated...";
            break;
            
        case ABOUT_SECTION:
            return nil;
            break;
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case CATALOG_SECTION:
            return 0;
            break;
        
        case ABOUT_SECTION:
            return 0;
            break;
            
        case 2:
            return 100;
            break;
            
        default:
            return 0;
            break;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case CATALOG_SECTION:
            return nil;
            break;
            
        case ABOUT_SECTION:
            return nil;
            break;
            
        case 2:
            return @"TIP: Try a long-press on an address or phone number for more options =)";
            break;
            
        default:
            return nil;
            break;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        
        switch (indexPath.section) {
            case CATALOG_SECTION:
            {
                cell.textLabel.text = localLastModString;
                cell.detailTextLabel.hidden = NO;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.accessoryView.hidden = NO;
                break;
            }
                
            case ABOUT_SECTION:
            {
                cell.textLabel.text = @"About this app";
                cell.detailTextLabel.hidden = NO;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.accessoryView.hidden = NO;
                break;
            }
                
            default:
                break;
        }
        
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"Cell with section %d indexPath %d was selected", indexPath.section, indexPath.row);
    
    switch (indexPath.section) {
        case CATALOG_SECTION:
        {
            alertCheckForUpdate = [[UIAlertView alloc] initWithTitle:@"Check for Updates?" message:@"Would you like to check for an updated version of the catalog now?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alertCheckForUpdate show];
            /*
            if ([localLastModString isEqualToString:NEVER_UPDATED_STRING]) {
                alertOptionDownload = [[UIAlertView alloc] initWithTitle:@"Download" message:@"Updated catalog available, would you like to download?"
                                                                delegate:self
                                                       cancelButtonTitle:@"NO"
                                                       otherButtonTitles:@"YES", nil];
                [alertOptionDownload show];
            } else {
                NSLog(@"Catalog sub menu");
                alertCheckForUpdate = [[UIAlertView alloc] initWithTitle:@"Check for Updates?" message:@"Would you like to check for an updated version of the catalog now?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alertCheckForUpdate show];
            }
            */
            break;
        }
            
            
        case ABOUT_SECTION:
        {
            NSLog(@"About sub menu");
            ChildViewController* nCVC = [[ChildViewController alloc] init];
            nCVC.parentString = @"About";
            nCVC.childName = @"About this app";
            [self.navigationController pushViewController:nCVC animated:YES];
            break;
        }
            
            
        default:
            break;
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (alertView == alertCheckForUpdate) {
        switch (buttonIndex) {
            case YES_BUTTON:
            {
                
                /* check server for last modified time */
                NSMutableURLRequest* modReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[CatalogFx serverUrl]]
                                                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                  timeoutInterval:10.0f];
                [modReq setHTTPMethod:@"HEAD"];
                NSURLConnection* connect = [[NSURLConnection alloc] initWithRequest:modReq delegate:self];
                connect = nil;
                
                [DejalBezelActivityView activityViewForView:self.view withLabel:@"Checking..."];
                
                break;
            }
            default:
                NSLog(@"Cancelled with button index %d", buttonIndex);
                break;
        }
    } else if (alertView == alertOptionDownload) {
        switch (buttonIndex) {
            case YES_BUTTON:
            {
                NSLog(@"Start download");
                NSURLRequest* downloadFile = [NSURLRequest requestWithURL:[NSURL URLWithString:[CatalogFx serverUrl]]
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:60.0f];
                
                zipDownload = [[NSMutableData alloc] init];
                
                NSURLConnection* connect = [[NSURLConnection alloc] initWithRequest:downloadFile delegate:self];
                connect = nil;
                
                [DejalBezelActivityView activityViewForView:self.view withLabel:@"Downloading..."];
                break;
            }
            default:
                NSLog(@"Cancelled with button index %d", buttonIndex);
                break;
        }
        
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"didReceiveResponse");
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
    /* HEADer received, get last modified date and compare to local version */
    if ([[[connection currentRequest] HTTPMethod] isEqualToString:@"HEAD"]) {       // check head information for last mod timestamp
        //NSLog(@"Method is equal to head");
        
        NSDictionary* returnDict = [(NSHTTPURLResponse*) response allHeaderFields];         // get status code to ensure file exists (HTTP 200)
        
        NSString* contentLength = [returnDict objectForKey:@"Content-Length"];
        NSLog(@"Content-Length %@", contentLength);
        catalodDownloadSize = [contentLength floatValue];
        
        NSInteger statusCode = [(NSHTTPURLResponse*) response statusCode];
        NSLog(@"Status code %i", statusCode);
        

        if (statusCode == 200) {
            
            NSString* serverLastMod = [returnDict objectForKey:@"Last-Modified"];                     // get last mod string from header
            
            if ([CatalogFx localCatalogShouldBeUpdated:serverLastMod ifFileNotFound:YES]) {
                NSString* fileSizeString = [CatalogFx convertFileSizeStringFromHeader:contentLength];
          
                alertOptionDownload = [[UIAlertView alloc] initWithTitle:@"Update?"
                                                                         message:[NSString stringWithFormat:@"An updated catalog is available, would you like to download? \nTotal size: %@", fileSizeString]
                                                                        delegate:self
                                                               cancelButtonTitle:@"NO"
                                                               otherButtonTitles:@"YES", nil];
                [alertOptionDownload show];
                
            } else {
                
                UIAlertView* alertNoUpdates = [[UIAlertView alloc] initWithTitle:@"Finished Checking" message:@"You already have the latest catalog" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertNoUpdates show];
            }
        } else {

            UIAlertView* alertNoUpdates = [[UIAlertView alloc] initWithTitle:@"Finished Checking" message:@"No updates available at this time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertNoUpdates show];
        }
        
        
    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [zipDownload appendData:data];
    float progress = ((float)[zipDownload length] / catalodDownloadSize) * 100;
    [DejalBezelActivityView activityViewForView:self.view withLabel:[NSString stringWithFormat:@"%0.0f%% Complete", progress] width:0 animate:NO ];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    
    NSString* catalogPath = [CatalogFx localZipFilePath];
    
    if ([[[connection currentRequest] HTTPMethod] isEqualToString:@"HEAD"]) {
        return;
    }
    
    if ([zipDownload length] >= 1) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:catalogPath]) {
            NSLog(@"Creating Zip file path: %@", catalogPath);
            [[NSFileManager defaultManager] createFileAtPath:catalogPath contents:nil attributes:nil];
            NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingAtPath:catalogPath];
            [fileHandle writeData:zipDownload];
            [CatalogFx unzipToDocumentsDirectory];
            
            [self.delegate refreshCatalog:self];
            
        } else {       // this case should not come up
            NSLog(@"Zip file exists");
            NSError* error = nil;
            if (![[NSFileManager defaultManager] removeItemAtPath:catalogPath error:&error]) {
                NSLog(@"Error removing file: %@", error);
            } else {
                NSLog(@"Zip file deleted");
            }
        }
        [DejalBezelActivityView removeViewAnimated:NO];
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Download Complete" width:0 animate:NO];
        [self performSelector:@selector(delayDownloadCompleteNotification) withObject:nil afterDelay:1];
        //[DejalBezelActivityView removeViewAnimated:YES];
    } else {
        [DejalBezelActivityView removeViewAnimated:YES];
        UIAlertView* errorDownload = [[UIAlertView alloc] initWithTitle:@"Download Error" message:@"Please check the internet connection or try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [errorDownload show];
        NSLog(@"Downloaded file size is 0");
    }
    
    
}

-(void)delayDownloadCompleteNotification{
    //[DejalBezelActivityView activityViewForView:nLVC.view withLabel:@"Download Complete"];
    //[self performSelector:@selector(delayDownloadCompleteNotification) withObject:nil afterDelay:1];
    [DejalBezelActivityView removeViewAnimated:YES];
}

@end
