//
//  CalendarViewController.m
//  shanghai
//
//  Created by Frank Yin on 10/16/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "CalendarViewController.h"
#import "DisplayFx.h"
#import "RXMLElement.h"
#import "XmlFx.h"
#import "ChildItem.h"
#import "EventItem.h"
#import "ChildViewAlert.h"
#import "StringFx.h"
#import "CatalogFx.h"
#import "DisplayFx.h"


@interface CalendarViewController ()

@end

@implementation CalendarViewController

@synthesize tableView;
@synthesize disableBack;
@synthesize disableMap;
@synthesize disableSearch;
@synthesize disableShare;
@synthesize childName;
@synthesize parentString;
@synthesize color;

-(void)loadView {
    
    /* initialize navigation controller top bar */
    UIBarButtonItem* backbarbutton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                      style:UIBarButtonSystemItemAdd
                                                                     target:nil
                                                                     action:nil];
    [backbarbutton setTintColor:[UIColor darkGrayColor]];
    self.navigationItem.backBarButtonItem = backbarbutton;
    self.navigationItem.title = childName;
    
    /* initialize bottom toolbar */
    self.navigationController.toolbarHidden = YES;
    
    /* initialize main view */
    self.view = [[UIView alloc] init];
    
    [self createData];
    
    tableView = [[UITableView alloc] init];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    
    [tableView setNeedsLayout];
}

-(void) createData {
    DLog(@"Creating Calendar data");
    
    NSArray* childArray = [XmlFx findChild:childName parent:parentString color:color];
    
    NSArray* enumArray;
    ChildItem* calendarRoot;
    if ([childArray count] == 1) {
        calendarRoot = [childArray objectAtIndex:0];
        enumArray = [XmlFx findCalendar:childName
                                 parent:parentString
                                  color:color
                               linkPath:calendarRoot.attributeLink];
    } else {
        NSLog(@"Something went wrong while creating calendar data for %@", childName);
    }
    
    calendarValues = [enumArray copy];
    eventHeights = [[NSMutableArray alloc] initWithCapacity:[calendarValues count]];
    for (NSInteger i=0; i < [calendarValues count]; i++) {
        
        EventItem* eventItem = [calendarValues objectAtIndex:i];

        NSNumber* num = [NSNumber numberWithFloat:(42 + [self calculateEventLabel:eventItem.textTitle summary:eventItem.textDescription smallPrint:eventItem.textSmallPrint])];
        [eventHeights addObject:num];
    }
    DLog(@"Height: %@", eventHeights);
    //DLog(@"%@", calendarValues);
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [calendarValues count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [[eventHeights objectAtIndex:indexPath.row] floatValue] + 32;  // for some reason the 32 needed to be added in order for the date labels to draw ?!?
}

-(void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        [self.tableView reloadData];
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    EventItem* eventItem = [calendarValues objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel* dateLabel = [self drawDateLabelFrom:eventItem.dateStart to:eventItem.dateEnd color:eventItem.color];
        [cell.contentView addSubview:dateLabel];
        
        UILabel* eventLabel = [self drawEventLabel:indexPath.row title:eventItem.textTitle summary:eventItem.textDescription smallPrint:eventItem.textSmallPrint];
        [cell.contentView addSubview:eventLabel];
        
        
        

        
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

/***********************
 Draws the date label, total height is fixed at 37 px
 ***********************/
-(UILabel*)drawDateLabelFrom:(NSString*)sDate to:(NSString*)eDate color:(NSString*)cColor {
    
    UILabel* dateLabel;
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320.0, 32.0)];
    dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    dateLabel.backgroundColor = [DisplayFx colorWithHexString:@"f4f4f4"];
    
    NSDate* startDate = [StringFx convertStringToDate:sDate format:@"yyyyMMdd"]; //20121017
    NSDate* endOfCurrentYear = [StringFx convertStringToDate:@"20121231" format:@"yyyyMMdd"];
    NSDateFormatter* dowFormat = [[NSDateFormatter alloc] init];
    dowFormat.dateFormat = @"EEEE";
    NSString* dayOfWeekString = [dowFormat stringFromDate:startDate];
    
    UILabel* dowSubLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, 300, 15)];
    dowSubLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    dowSubLabel.text = dayOfWeekString;
    dowSubLabel.textColor = [DisplayFx colorWithHexString:@"333333"];
    dowSubLabel.font = [UIFont systemFontOfSize:10.5];
    dowSubLabel.backgroundColor = [UIColor clearColor];
    [dateLabel addSubview:dowSubLabel];
    
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    if ([startDate compare:endOfCurrentYear] == NSOrderedAscending) {
        dateFormat.dateFormat = @"MMMM dd"; // startDate is CurrentYear, don't show year
    } else {
        dateFormat.dateFormat = @"MMMM dd, yyyy";
    }
    NSString* dateString = [dateFormat stringFromDate:startDate];
    UILabel* dateSubLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.1, 11, 300, 21)];
    dateSubLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    dateSubLabel.text = dateString;
    dateSubLabel.textColor = [DisplayFx colorWithHexString:@"333333"];
    dateSubLabel.font = [UIFont systemFontOfSize:15.0];
    dateSubLabel.backgroundColor = [UIColor clearColor];
    [dateLabel addSubview:dateSubLabel];
    
    UILabel* colorSpacer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, 32)];
    colorSpacer.backgroundColor = [DisplayFx colorWithHexString:cColor];
    [dateLabel addSubview:colorSpacer];
    
    
    
    return dateLabel;
}


/***********************
 Draws the event text label, starting y offset should be below date's height
 ***********************/
-(UILabel*)drawEventLabel:(NSInteger)index title:(NSString*)eTitle summary:(NSString*)eSummary smallPrint:(NSString*)eSmallPrint {
    
    
    
    UILabel* eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, 320, [[eventHeights objectAtIndex:index] floatValue])];
    //eventLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    eventLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    float yDrawPosition = 5;
    float eventNameLabelHeight = 20;
    
    UILabel* eventName = [[UILabel alloc] initWithFrame:CGRectMake(15, yDrawPosition, 300.0, eventNameLabelHeight)];  // size & position are fixed
    yDrawPosition = yDrawPosition + eventNameLabelHeight;
    eventName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //eventName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    eventName.text = eTitle;
    eventName.font = [UIFont boldSystemFontOfSize:14.0];
    eventName.textAlignment = NSTextAlignmentLeft;
    eventName.textColor = [UIColor blackColor];
    [eventLabel addSubview:eventName];
    
    
    CGSize labelSize = CGSizeMake(300, 10000);
    
    if ([eSummary length] > 0) {
        UILabel* eventDescription;
        labelSize = [eSummary sizeWithFont:[UIFont systemFontOfSize:12.0]
                         constrainedToSize:CGSizeMake(labelSize.width, labelSize.height)
                             lineBreakMode:NSLineBreakByWordWrapping];
        
        
        yDrawPosition = yDrawPosition + 5;
        eventDescription = [[UILabel alloc] initWithFrame:CGRectMake(15, yDrawPosition, 300.0, labelSize.height)];  // height is dynamic, position is fixed
        yDrawPosition = yDrawPosition + labelSize.height;
        eventDescription.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        eventDescription.text = eSummary;
        eventDescription.font = [UIFont systemFontOfSize:12.0];
        eventDescription.textAlignment = NSTextAlignmentLeft;;
        eventDescription.lineBreakMode = NSLineBreakByWordWrapping;
        eventDescription.numberOfLines = 0;
        eventDescription.textColor = [DisplayFx colorWithHexString:@"222222"];
        [eventLabel addSubview:eventDescription];
    }
    
    if ([eSmallPrint length] > 0) {
        UILabel* eventSmallPrint;
        labelSize = [eSmallPrint sizeWithFont:[UIFont systemFontOfSize:12.0]
                            constrainedToSize:CGSizeMake(labelSize.width, labelSize.height)
                                lineBreakMode:NSLineBreakByWordWrapping];
        //DLog(@"%@ description bounds height: %f width:%f", eTitle, eventDescription.bounds.size.height, eventDescription.bounds.size.width);
        yDrawPosition = yDrawPosition + 5;
        eventSmallPrint = [[UILabel alloc] initWithFrame:CGRectMake(15, yDrawPosition, 300.0, labelSize.height)];
        yDrawPosition = yDrawPosition + labelSize.height;
        
        eventSmallPrint.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //eventSmallPrint.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        eventSmallPrint.text = eSmallPrint;
        eventSmallPrint.font = [UIFont italicSystemFontOfSize:11.0];
        eventSmallPrint.textAlignment = NSTextAlignmentLeft;
        eventSmallPrint.lineBreakMode = NSLineBreakByWordWrapping;
        eventSmallPrint.numberOfLines = 0;
        eventSmallPrint.textColor = [DisplayFx colorWithHexString:@"222222"];
        [eventLabel addSubview:eventSmallPrint];
    }
    
    //DLog(@"ydrawposition: %f", yDrawPosition);
    return eventLabel;
}

-(float)calculateEventLabel:(NSString*)eTitle summary:(NSString*)eSummary smallPrint:(NSString*)eSmallPrint {
    
    
    

    //eventLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    float yDrawPosition = 25; // origin.y + eventNameLabel.height
    
    CGSize labelSize = CGSizeMake(300, 10000);
    
    if ([eSummary length] > 0) {

        labelSize = [eSummary sizeWithFont:[UIFont systemFontOfSize:12.0]
                         constrainedToSize:CGSizeMake(labelSize.width, labelSize.height)
                             lineBreakMode:NSLineBreakByWordWrapping];
        
        
        yDrawPosition = yDrawPosition + 5;
        yDrawPosition = yDrawPosition + labelSize.height;
    }
    
    if ([eSmallPrint length] > 0) {
        labelSize = [eSmallPrint sizeWithFont:[UIFont systemFontOfSize:12.0]
                            constrainedToSize:CGSizeMake(labelSize.width, labelSize.height)
                                lineBreakMode:NSLineBreakByWordWrapping];
        yDrawPosition = yDrawPosition + 5;
        yDrawPosition = yDrawPosition + labelSize.height;
        
    }
    

    return yDrawPosition;
}




@end
