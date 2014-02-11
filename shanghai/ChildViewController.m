//
//  ChildViewController.m
//  shanghai
//
//  Created by Frank Yin on 9/14/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "ChildViewController.h"
#import "MapViewController.h"
#import "DisplayFx.h"
#import "RXMLElement.h"
#import "XmlFx.h"
#import "ChildItem.h"
#import "ChildViewAlert.h"
#import "StringFx.h"
#import "CatalogFx.h"
#import "DisplayFx.h"


@interface ChildViewController ()

@end

@implementation ChildViewController
UILabel* colorSpacer;


@synthesize tableView;
@synthesize disableBack;
@synthesize disableMap;
@synthesize disableSearch;
@synthesize disableShare;
@synthesize childName;
@synthesize parentString;
@synthesize color;
@synthesize objectOfInterest;
@synthesize highlightObjectOfInterest;

- (void) loadView {
    
    self.view = [[UIView alloc] init];
    
    /* initialize navigation controller top bar */
    UIBarButtonItem* backbarbutton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemAdd target:nil action:nil];
    self.navigationItem.backBarButtonItem = backbarbutton;
    self.navigationItem.title = childName;
    
    
    /* initialize bottom toolbar */
    self.navigationController.toolbarHidden = YES;
    
    /* initialize main view */
    [self createData];
    
    tableView = [[UITableView alloc] init];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    
    //[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.65; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
    
}

- (void) createData {
    DLog(@"ChildView creating data, color is %@", color);
    
    /* parse XML file for child data */
    NSArray* enumArray = [XmlFx findChild:childName parent:parentString color:color] ;
    
    childValues = [[NSMutableArray alloc] init];
    
    BOOL containsMap = NO;
    
    for (ChildItem* cItem in enumArray) {
        
        if ([[cItem.attributeName lowercaseString] isEqualToString:@"name"]) {
            self.navigationItem.title = cItem.attributeValue;           
        } else {
            if ((cItem.isGeoLink) && (!containsMap)) {
                UIBarButtonItem* mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(mapChildAddresses)];
                self.navigationItem.rightBarButtonItem = mapButton;
                containsMap = YES;
            }
            [childValues addObject:cItem];

                            
            if ([[cItem.attributeName lowercaseString] isEqualToString:[self.objectOfInterest lowercaseString]]) {
                scrollToIndex = [childValues indexOfObject:cItem];
                DLog(@"childAttributeName: %@ objectOfInterest:%@ index:%d", cItem.attributeName, self.objectOfInterest, scrollToIndex);

            }
        }
    }
}

-(void) mapChildAddresses {
    DLog(@"Map button clicked");
    
    MapViewController* nMVC = [[MapViewController alloc] init];
    nMVC.mapTitle = self.navigationItem.title;
    nMVC.isSingleView = NO;
    nMVC.isChildView = YES;
    NSMutableArray* mapArray = [[NSMutableArray alloc] init];
    for (ChildItem* cItem in childValues) {
        if (cItem.isGeoLink) {
            [mapArray addObject:cItem];
        }
        
    }
    
    
    nMVC.geoChildItems = mapArray;
    if (nMVC.geoChildItems.count > 0) {
        [self.navigationController pushViewController:nMVC animated:YES];
    } else {
        DLog(@"No maps to show");
    }
    
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [childValues count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize labelSize = CGSizeMake(300.0, 20.0);
    ChildItem* childAtt = [childValues objectAtIndex:indexPath.row];
    
    if (childAtt.isImage) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:childAtt.imagePath]) {
            labelSize = [DisplayFx image:[UIImage imageWithContentsOfFile:childAtt.imagePath] fitToSize:CGSizeMake(200, 200)];   // minus 45 to compensate for excessive separation
            labelSize.height = labelSize.height - 40;
        } else {
            return 0;
        }
    } else if ([childAtt.attributeValue length] > 0) {
        labelSize = [childAtt.attributeValue sizeWithFont:[UIFont boldSystemFontOfSize:14.0]
                                        constrainedToSize:CGSizeMake(self.tableView.frame.size.width - 20, 10000)   // subtract 20 for the borders when displaying
                                            lineBreakMode:NSLineBreakByWordWrapping];
        
    }
    
    return 55.0 + labelSize.height;
    
    
}



- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"Creating cell at row:%d section:%d", indexPath.row, indexPath.section);
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ChildItem* childAttribute = [childValues objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        
        
        BOOL importantCell = NO;
        if (highlightObjectOfInterest) {
            if (scrollToIndex == indexPath.row) {
                importantCell = YES;
                cell.contentView.backgroundColor = [UIColor yellowColor];
            }
        }
        
        if (childAttribute.isImage) {
            UILabel* imageLabel;
            imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
            
            NSString* imagePath = childAttribute.imagePath;
            DLog(@"Display image from path: %@", imagePath);
            
            UIImage* imageFile = [UIImage imageWithContentsOfFile:imagePath];
            imageLabel.contentMode = UIViewContentModeScaleToFill;
            
            imageLabel.backgroundColor = [UIColor colorWithPatternImage:[DisplayFx imageWithImage:imageFile scaledAspectToSize:imageLabel.frame.size]];
            //imageLabel.backgroundColor = [UIColor colorWithPatternImage:imageFile];
            //[imageLabel sizeToFit];
            [cell.contentView addSubview:imageLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.backgroundColor = [DisplayFx colorWithHexString:@"ECECEC"];
            
            
            UILabel* nameLabel;
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300.0, 24.0)];
            nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            nameLabel.text = childAttribute.attributeName;
            nameLabel.font = [UIFont boldSystemFontOfSize:12.0];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.textColor = [DisplayFx colorWithHexString:@"111111"];
            nameLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:nameLabel];
            
            
            if ([childAttribute.attributeValue length] > 0) {
                UILabel* dividerLabel;
                dividerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 34, 300.0, 1.0)];
                dividerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                dividerLabel.backgroundColor = [UIColor darkGrayColor];
                [cell.contentView addSubview:dividerLabel];
                
                UILabel* valueLabel;
                CGSize valueSize = [childAttribute.attributeValue sizeWithFont:[UIFont boldSystemFontOfSize:14.0]
                                                             constrainedToSize:CGSizeMake(self.tableView.frame.size.width - 20, 10000)
                                                                 lineBreakMode:NSLineBreakByWordWrapping];
                valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 37, 300, valueSize.height)];
                valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                valueLabel.text = childAttribute.attributeValue;
                valueLabel.font = [UIFont boldSystemFontOfSize:14.0];
                //valueLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
                valueLabel.textAlignment = NSTextAlignmentLeft;
                valueLabel.textColor = [DisplayFx colorWithHexString:@"333333"];
                valueLabel.numberOfLines = 0;
                valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
                valueLabel.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:valueLabel];
                if ([childAttribute.attributeLink length] != 0) {
                    valueLabel.textColor = [UIColor blueColor];
                } else {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
            } else {
                nameLabel.font = [UIFont italicSystemFontOfSize:12.0];
                nameLabel.textColor = [DisplayFx colorWithHexString:@"333333"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChildItem* childAtt =  [childValues objectAtIndex:indexPath.row];
    if (childAtt.isGeoLink) {
        DLog(@"Open Geo");
        MapViewController* nMVC = [[MapViewController alloc] init];
        
        nMVC.mapTitle = self.navigationItem.title;
        nMVC.childItem = childAtt;
        nMVC.isSingleView = YES;
        
        [self.navigationController pushViewController:nMVC animated:YES];
        
    }else if (childAtt.isTelLink) {
        DLog(@"Open Tel");
        
        UIDevice* device = [UIDevice currentDevice];
        DLog(@"device mode currently set as %@", [device model]);
        if ([[device model] isEqualToString:@"iPhone"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:childAtt.attributeLink]];
        } else {
            NSArray* telComponents = [childAtt.attributeLink componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
            DLog(@"Array %@", telComponents);
            
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:[telComponents objectAtIndex:1]];
            
            UIAlertView* notpermitted = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support phone calling. The number is copied to your clipboard." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [notpermitted show];
        }
        
        
    }else if (childAtt.isWebLink) {
        DLog(@"Open Web");
        NSURL* url = [NSURL URLWithString:childAtt.attributeLink];
        if (![[UIApplication sharedApplication] openURL:url]) {
            DLog(@"%@%@", @"Failed to open url:", [url description]);
            
            UIAlertView* failedUrl = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"URL failed to open" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [failedUrl show];
            
        }
    } else if (childAtt.isEmailLink) {
        DLog(@"Open Email Link");
        
        MFMailComposeViewController* mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObject:childAtt.attributeLink]];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        DLog(@"long press on non-row element");
    } else {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            DLog(@"long press on row %d", indexPath.row);
            
            ChildItem* childAtt =  [childValues objectAtIndex:indexPath.row];
            if (!childAtt.isImage) {
                ChildViewAlert* alert = [[ChildViewAlert alloc] initWithChild:[childValues objectAtIndex:indexPath.row] childViewController:self];
                
                [alert show];
            }
        }
    }
}

-(void)launchTaxiCard:(ChildViewAlert *)controller text:(NSString *)text {
    DLog(@"Returned: %@", text);
}


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            DLog(@"MessageComposeResultCancelled");
            break;
            
        case MessageComposeResultFailed:
            DLog(@"MessageComposeResultFailed");
            break;
            
        case MessageComposeResultSent:
            DLog(@"MessageComposeResultSent");
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            DLog(@"MFMailComposeResultCancelled");
            break;
        case MFMailComposeResultFailed:
            DLog(@"MFMailComposeResultFailed");
            break;
        case MFMailComposeResultSaved:
            DLog(@"MFMailComposeResultSaved");
            break;
        case MFMailComposeResultSent:
            DLog(@"MFMailComposeResultSent");
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewDidAppear:(BOOL)animated {
    /*
     float navHeight = self.navigationController.navigationBar.bounds.size.height;
     float winHeight = self.view.window.bounds.size.height;
     
     colorSpacer = [[UILabel alloc] initWithFrame:CGRectMake(0, navHeight, 5, winHeight - navHeight)];
     
     CAGradientLayer* gradient = [CAGradientLayer layer];
     gradient.frame = colorSpacer.bounds;
     [gradient setStartPoint:CGPointMake(0, 0.5)];
     [gradient setEndPoint:CGPointMake(1, 0.5)];
     gradient.colors = [NSArray arrayWithObjects:(id)[[DisplayFx colorWithHexString:color] CGColor], (id)[[DisplayFx colorWithHexString:@"ECECEC"] CGColor], nil];
     [colorSpacer.layer insertSublayer:gradient above:0];
     
     colorSpacer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
     colorSpacer.backgroundColor = [DisplayFx colorWithHexString:color];
     [self.navigationController.navigationBar addSubview:colorSpacer];
     */
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    DLog(@"willRotateToInterfaceOrientation reloadData");
    [tableView reloadData];     // re-measure variable spacing for all the child attributes on screen rotation
    //[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:scrollToIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollToIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    DLog(@"viewWillAppear reloadData");
    [tableView reloadData];     // re-measure variable spacing for all the child attributes when returning to (and launching...) the screen
    //[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:scrollToIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollToIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);

}

@end
