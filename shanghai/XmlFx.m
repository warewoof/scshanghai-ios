//
//  XmlFx.m
//  shanghai
//
//  Created by Frank Yin on 9/14/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "XmlFx.h"
#import "RXMLElement.h"
#import "ListItem.h"
#import "ChildItem.h"
#import "EventItem.h"
#import "StringFx.h"
#import "DebugFx.h"

@implementation XmlFx

+(RXMLElement*) getRootHandle {
    
    NSArray* dirPaths;
    NSString* docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];    
    
    NSString* catalogPath = [docsDir stringByAppendingPathComponent:@"catalog.xml"];

    if ([[NSFileManager defaultManager] fileExistsAtPath:catalogPath]) {
        DLog(@"Local Catalog Exists at %@", catalogPath);
        NSData* xmlData = [NSData dataWithContentsOfFile:catalogPath];
        return [RXMLElement elementFromXMLData:xmlData];            // local directory
    } else {
        DLog(@"Local Catalog Does Not Exist: %@", catalogPath);
        return [RXMLElement elementFromXMLFile:@"catalog.xml"];     // app resource default
    }
    
}

+(RXMLElement*) getEventHandle:(NSString*)path {
    NSArray* dirPaths;
    NSString* docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    NSString* eventPath = [docsDir stringByAppendingPathComponent:path];
    DLog(@"%@", eventPath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:eventPath]) {
        DLog(@"Event File Exists");
        NSData* xmlData = [NSData dataWithContentsOfFile:eventPath];
        return [RXMLElement elementFromXMLData:xmlData];            // local directory
    } else {
        return [RXMLElement elementFromXMLFile:@"events.xml"];     // app resource default
    }
    
}

+(NSArray*) findList:(NSString*)section parent:(NSString*)parent {
    
    __block RXMLElement* rootXML = [self getRootHandle];
    
    DLog(@"Looking in TOC for %@, %@", parent, section);
    
    __block RXMLElement* foundNode;
    
    NSString* xQuery = [NSString stringWithFormat:@"//*[@name='%@']/*[@name='%@']",parent, section];
    [rootXML iterateWithRootXPath:xQuery usingBlock:^(RXMLElement* repElement) {
        DLog(@"Found: %@", [repElement attribute:@"name"]);
        foundNode = repElement;
        return;
    }];
    
    NSMutableArray* listArray = [[NSMutableArray alloc] init];
    [foundNode iterate:@"*" usingBlock:^(RXMLElement *element) {
        ListItem* listItem = [[ListItem alloc] initWithVars:[element attribute:@"name"] parent:section color:[element attribute:@"color"]];
        if ([[element.tag lowercaseString] isEqualToString:@"child"]) {
            listItem.isChild = YES;
        } else if ([[element.tag lowercaseString] isEqualToString:@"calendar"]) {
            listItem.isCalendar = YES;
        }
        [listArray addObject:listItem];
        
    }];
    
    return listArray;
}

+(NSArray*) findChild:(NSString*)child parent:(NSString*)parent color:(NSString*)color {
    
    __block RXMLElement* rootXML = [self getRootHandle];
    
    DLog(@"Looking in Children for %@, %@", parent, child);
    
    __block RXMLElement* foundNode;
    
    DebugFx* debug = [[DebugFx alloc] initWithName:@"findChild"];
    [debug start];


    NSString* xPath = [NSString stringWithFormat:@"/directory/children/child[@name=\"%@\"]", child];
    [rootXML iterateWithRootXPath:xPath usingBlock:^(RXMLElement* element) {
        if ([[element attribute:@"parent"] rangeOfString:parent].location != NSNotFound) {
        foundNode = element;
        }
    }];
    
    if (foundNode == nil) {
        DLog(@"Child not found for %@", xPath);
    } else {
        DLog(@"Found %@", foundNode.tag);
    }
    
    
    NSMutableArray* listArray = [[NSMutableArray alloc] init];
    [foundNode iterate:@"*" usingBlock:^(RXMLElement *element) {
        ChildItem* childItem = [[ChildItem alloc] initWithVars:child parent:parent color:color
                                                          name:[element attribute:@"name"]
                                                         value:[element attribute:@"value"]
                                                          link:[element attribute:@"link"]
                                                       options:[element attribute:@"options"]];
        [listArray addObject:childItem];
    }];
    [debug stop];
    [debug stats];
    
    return listArray;
}

+(NSArray*) findCalendar:(NSString*)child parent:(NSString*)parent color:(NSString*)color linkPath:(NSString*)path{
    
    __block RXMLElement* rootXML = [self getEventHandle:path];
    
    DLog(@"Looking in %@ for events",path);
    
    NSMutableArray* indexArray = [[NSMutableArray alloc] init];

    
    [rootXML iterate:@"event" usingBlock:^(RXMLElement* element) {
        [indexArray addObject:element];
    }];

    DLog(@"Event Count %d", [indexArray count]);
    
    NSMutableArray* listArray = [[NSMutableArray alloc] init];
    
    for (RXMLElement* eNode in indexArray) {
        
        EventItem* event = [[EventItem alloc] initiWithVars:child parent:parent color:color];
        
        [eNode iterate:@"*" usingBlock:^(RXMLElement *element) {
            
            if ([[[element tag] lowercaseString] isEqualToString:@"date"]) {
                event.dateText = [element attribute:@"text"];
                event.dateStart = [element attribute:@"startdate"];
                event.dateEnd = [element attribute:@"enddate"];
            } else if ([[[element tag] lowercaseString] isEqualToString:@"description"]) {
                event.textTitle = [element attribute:@"title"];
                event.textDescription = [element attribute:@"summary"];
                event.textSmallPrint = [element attribute:@"smallprint"];
            } else if ([[[element tag] lowercaseString] isEqualToString:@"location"]) {
                event.locationText = [element attribute:@"text"];
                event.locationLink = [element attribute:@"link"];
            } else if ([[[element tag] lowercaseString] isEqualToString:@"link"]) {
                event.linkText = [element attribute:@"text"];
                event.linkLink = [element attribute:@"link"];
            }
        }];
        [listArray addObject:event];
    }
    
    return listArray;
}



+(BOOL) isChild:(NSString*)child parent:(NSString*) parent {

    __block RXMLElement* rootXML = [self getRootHandle];

    __block BOOL isChild = NO;
    child = [StringFx escapeXml:child];
    parent = [StringFx escapeXml:parent];
    
    NSString* xQuery = [NSString stringWithFormat:@"//*[@name='%@']/*[@name='%@']",parent, child];
    DLog(@"Checking child query string: %@", xQuery);
    [rootXML iterateWithRootXPath:xQuery usingBlock:^(RXMLElement* repElement) {
        DLog(@"Found: %@", [repElement attribute:@"name"]);
        if ([repElement.tag isEqualToString:@"child"]) {
            isChild = YES;
            return;
        }
    }];
    return isChild;
}

+(NSArray*) findListGeo:(NSString*)section parent:(NSString*)parent {
    
    DLog(@"Preparing list of GEO childItems for %@, %@...", section, parent);
    DebugFx* debug = [[DebugFx alloc] initWithName:@"findListGeo"];
    [debug start];
    
    __block RXMLElement* rootXML = [self getRootHandle];
    
    
    DebugFx* miniRoutines = [[DebugFx alloc] initWithName:@"creatining list of section's subsection"];
    [miniRoutines start];
    /* first create complete list of section's sub-sections */
    NSMutableArray* sectionList = [[NSMutableArray alloc] init];
    NSString* xQuery = [NSString stringWithFormat:@"//*[@name='%@']/*[@name='%@']//*",parent, section];
    [rootXML iterateWithRootXPath:xQuery usingBlock:^(RXMLElement* repElement) {
        
        if (![repElement.tag isEqualToString:@"child"]) {
            [sectionList addObject:repElement];
        }
        
    }];
    //this is needed to add the node of top section, to capture the children sharing top level as additional lists
    xQuery = [NSString stringWithFormat:@"//*[@name='%@']/*[@name='%@']",parent, section];
    [rootXML iterateWithRootXPath:xQuery usingBlock:^(RXMLElement* repElement) {
        DLog(@"Found: %@", [repElement attribute:@"name"]);
        [sectionList addObject:repElement];
    }];
    [miniRoutines stop];
    [miniRoutines stats];
    
    
    miniRoutines.name = @"collecting children from each subsection";
    [miniRoutines start];
    
    /* Second, collect all the children from each subsection.  (Subsection list was created in order to extract the "parent" name) */
    NSMutableArray* childrenFilteredList = [[NSMutableArray alloc] init];
    for (RXMLElement* sectionElement in sectionList) {
        [sectionElement iterate:@"child" usingBlock:^(RXMLElement* childElement) {
            //DLog(@"Child found: %@, parent: %@", [childElement attribute:@"name"], [sectionElement attribute:@"name"]);
            ListItem* newItem = [[ListItem alloc] initWithVars:[childElement attribute:@"name"]
                                                        parent:[sectionElement attribute:@"name"]
                                                         color:[sectionElement attribute:@"color"]
                                                       isChild:YES];
            [childrenFilteredList addObject:newItem];
        }];
    }
    [miniRoutines stop];
    [miniRoutines stats];
    
    
    miniRoutines.name = @"filtering all geo items";
    [miniRoutines start];
    
    /* Third, filter through children list, find child node in children section, and collect all the children items that contain "geo" link */
    __block NSMutableArray* filteredGeoList = [[NSMutableArray alloc] init];
    

    [rootXML iterate:@"children.child" usingBlock:^(RXMLElement* element) {
        

        ListItem* itemToBeRemoved;
        for (ListItem* tempListItem in childrenFilteredList) {
            if (([[element attribute:@"name"] isEqualToString:tempListItem.name]) && ([[element attribute:@"parent"] rangeOfString:tempListItem.parentName].location != NSNotFound)) {
                //DLog(@"Storing child %@", tempListItem.name);
                [element iterate:@"*" usingBlock:^(RXMLElement *element) {
                    if ([[[element attribute:@"link"] lowercaseString] hasPrefix:@"geo:"]) {
                        ChildItem* childItem = [[ChildItem alloc] initWithVars:tempListItem.name parent:tempListItem.parentName color:tempListItem.color
                                                                          name:[element attribute:@"name"]
                                                                         value:[element attribute:@"value"]
                                                                          link:[element attribute:@"link"]
                                                                       options:[element attribute:@"options"]];
                        [filteredGeoList addObject:childItem];
                    }
                    
                }];
                itemToBeRemoved = tempListItem;
                break;
                

            }

        }
        [childrenFilteredList removeObjectIdenticalTo:itemToBeRemoved];
        

        
        
    }];
    [miniRoutines stop];
    [miniRoutines stats];
    
    [debug stop];
    [debug stats];
    
    return filteredGeoList;  // now we have an array of all the children geo links for this section!!!
    
    
}

@end
