//
//  ListViewController.m
//  shanghai
//
//  Created by Frank Yin on 9/6/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "ListViewController.h"
#import "ChildViewController.h"
#import "CalendarViewController.h"
#import "MenuViewController.h"
#import "DisplayFx.h"
#import "RXMLElement.h"
#import "XmlFx.h"
#import "ListItem.h"
#import "StringFx.h"
#import "MapViewController.h"
#import "DejalActivityView.h"



@interface ListViewController ()

@end

@implementation ListViewController


@synthesize tableView;
@synthesize disableBack;
@synthesize disableMap;
@synthesize disableSearch;
@synthesize disableShare;
@synthesize enableMenuButton;
@synthesize sectionString;
@synthesize parentString;
@synthesize color;

- (void) loadView {
    [super loadView];
    self.view = [[UIView alloc] init];

    /* set title and init navigation bar */
    self.navigationItem.title = sectionString;

    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemAdd target:nil action:nil];
    
    if (enableMenuButton) {
        UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(menuButtonPressed)];
        [self.navigationItem setLeftBarButtonItem:menuButton];
    } else {
        [self.navigationItem setLeftBarButtonItem:nil];
    }
    
    UIBarButtonItem* mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(mapSection)];
    self.navigationItem.rightBarButtonItem = mapButton;

    
    
    /* initialize bottom toolbar */
    self.navigationController.toolbarHidden = YES;
    
    
    
    /* initialize table data and set table delegate */
    [self createData];
    //tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 372) style:UITableViewStylePlain];
    tableView = [[UITableView alloc] init];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    DLog(@"LVC loadView did finish");
    /*
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.65; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
    */
        
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DLog(@"viewDidAppear");
    self.navigationController.toolbarHidden = YES;
}

- (void) createData {
    
    catalog = [XmlFx findList:[StringFx escapeXml:sectionString] parent:[StringFx escapeXml:parentString]];
    
}

/*
-(void)handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        DLog(@"long press on non-row element");
    } else {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            DLog(@"long press on row %d", indexPath.row);
            ListItem* lItem = [catalog objectAtIndex:indexPath.row];
            ListViewAlert* alert = [[ListViewAlert alloc] initWithListItem:lItem withViewController:self];
            [alert show];
        }
    }
}
*/


-(void) mapSection {
    DLog(@"Map button clicked");
    
    
    [NSThread detachNewThreadSelector:@selector(launchMapViewSpinner) toTarget:self withObject:nil];
    
    MapViewController* nMVC = [[MapViewController alloc] init];
    nMVC.mapTitle = self.navigationItem.title;
    nMVC.isSingleView = NO;    
    nMVC.geoChildItems = [XmlFx findListGeo:[StringFx escapeXml:sectionString] parent:[StringFx escapeXml:parentString]];

    if (nMVC.geoChildItems.count <= 0) {
        [DejalBezelActivityView removeViewAnimated:YES];
        DLog(@"No maps to show");
        UIAlertView* noMaps = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No maps to display for this sectoin" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noMaps show];
    } else {
        
        [self.navigationController pushViewController:nMVC animated:YES];
        
    }


    
}

-(void)launchMapViewSpinner {
    [DejalBezelActivityView activityViewForView:self.view];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [catalog count];
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ListItem* listItem = [catalog objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [DisplayFx colorWithHexString:@"ECECEC"];
        
        
        UILabel* label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300.0, 24.0)];
        //label.tag = 1;
        label.text = listItem.name;
        label.font = [UIFont boldSystemFontOfSize:16.0];
        //label.font = [UIFont fontWithName:@"Helvetica" size:16];
        label.textColor = [DisplayFx colorWithHexString:@"333333"];
        label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;;
        [cell.contentView addSubview:label];
        
        UILabel* colorSpacer;
        
        colorSpacer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, 43.0)];
        colorSpacer.backgroundColor = [DisplayFx colorWithHexString:listItem.color];
        [cell.contentView addSubview:colorSpacer];
        
        
                
        //cell = [UITableView alloc] initWithFrame:CGRectMake(5, 0.5, 240.0, 25.0)]
    }
    //cell.textLabel.text = [catalog objectAtIndex:indexPath.row];
    //cell.textLabel.textColor = [UIColor clearColor];
    //cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ListItem* listItem =  [catalog objectAtIndex:indexPath.row];
    //NSString* clickedItemString = [StringFx escapeXml:listItem.name];
    NSString* clickedItemString = listItem.name;
    
    
    if (listItem.isChild) {
        DLog(@"Open ChildView");
        ChildViewController* nCVC = [[ChildViewController alloc] init];
        nCVC.parentString = sectionString;
        nCVC.childName = clickedItemString;
        nCVC.color = listItem.color;
        
        
        [self.navigationController pushViewController:nCVC animated:YES];
        
    } else if (listItem.isCalendar) {
        DLog(@"Open CalendarView");
        CalendarViewController* nCVC = [[CalendarViewController alloc] init];
        nCVC.parentString = sectionString;
        nCVC.childName = clickedItemString;
        nCVC.color = listItem.color;
        
        
        [self.navigationController pushViewController:nCVC animated:YES];
        
    } else {
        DLog(@"Open ListView");
        ListViewController* nLVC = [[ListViewController alloc] init];
        nLVC.parentString = sectionString;
        nLVC.sectionString = clickedItemString;
        
        [self.navigationController pushViewController:nLVC animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void)menuButtonPressed {
    DLog(@"Menu Button Pressed");
    MenuViewController* nMVC = [[MenuViewController alloc] init];
    nMVC.delegate = self;
    [self.navigationController pushViewController:nMVC animated:YES];
}

-(void)refreshCatalog:(MenuViewController *)controller {
    DLog(@"Refresh passed back");
    ListViewController* nLVC = [[ListViewController alloc] init];
    nLVC.parentString = @"Simple City Shanghai";
    nLVC.sectionString = @"Shanghai";
    nLVC.enableMenuButton = YES;
    
    NSMutableArray* viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    [viewControllers replaceObjectAtIndex:0 withObject:nLVC];           // this will remove the original rootview listviewcontroller
    [self.navigationController setViewControllers:viewControllers];
    
}

@end
