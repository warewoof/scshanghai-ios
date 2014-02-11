//
//  AppFx.m
//  shanghai
//
//  Created by Frank Yin on 10/14/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "CatalogFx.h"
#import "SSZipArchive.h"
#import "StringFx.h"


@implementation CatalogFx

+(NSString*) serverUrl {
    return modeServerUrl;
}

+(NSString*) localCatalogFilePath {
    
    return [[self localDocumentsDirectory] stringByAppendingPathComponent:@"catalog.xml"];
    
}

+(NSString*) localZipFilePath {
    
    return [[self localDocumentsDirectory] stringByAppendingPathComponent:@"tempFile"];
    
}

+(NSString*) localDataDirectory {
    
    return [[self localDocumentsDirectory] stringByAppendingPathComponent:@"data"];
    
}

+(NSString*) localDocumentsDirectory {
    
    NSArray* dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [dirPaths objectAtIndex:0];
    
}


+(void) unzipToDocumentsDirectory {
    
    NSString* zipPath = [self localZipFilePath];                                // unzip saved Zip file to documents directory
    NSString* destinationPath = [self localDocumentsDirectory];
    [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];               // set date format to get the Zip file last mod date
    dateFormat.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];

    
    NSDictionary* dictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[self localZipFilePath] error:nil];
    NSDate* zipFileDate = [dictionary objectForKey:NSFileModificationDate];                                       // get local file last mod date
    DLog(@"Zip file mod time: %@", [dateFormat stringFromDate:zipFileDate]);
    
    NSDictionary* setAttrs = [NSDictionary dictionaryWithObjectsAndKeys:zipFileDate, NSFileModificationDate, nil];
    NSError* errorFile;
    
    if ([[NSFileManager defaultManager] setAttributes:setAttrs ofItemAtPath:[self localCatalogFilePath] error:&errorFile]) {
        DLog(@"Catalog Last Mod Timestamp set");
    } else {
        DLog(@"Catalog Last Mod Timestamp not set");
    }

    
    /* delete zip file */
    NSError* error = nil;
    if (![[NSFileManager defaultManager] removeItemAtPath:zipPath error:&error]) {
        DLog(@"Error removing file: %@", error);
    } else {
        DLog(@"Zip file deleted");
    }
}

+(BOOL)localCatalogShouldBeUpdated:(NSString*)serverLastMod ifFileNotFound:(BOOL)allowDownload;
{

    DLog(@"Server mod time: %@", serverLastMod);
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDate* serverDate = [dateFormat dateFromString:serverLastMod];                       // convert last mod string into date object
    
    NSString* catalogPath = [self localCatalogFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:catalogPath]) {            // check if local file exists
        NSDictionary* dictionary = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:catalogPath error:nil];
        NSDate* localDate = [dictionary objectForKey:NSFileModificationDate];       // get local file last mod date
        DLog(@"Local mod time: %@", [dateFormat stringFromDate:localDate]);
        
        if ([serverDate compare:localDate] == NSOrderedDescending) {
            return YES;
        } else {
            return NO;
        }
    } else {
        NSDate* localDate = [StringFx convertStringToDate:internalCatalogDate format:@"yyyyMMdd"];
        
        if (allowDownload) {
            return YES;
        } else if ([serverDate compare:localDate] == NSOrderedDescending) {
            return YES;
        } else {
            return NO;
        }
    }
}

+(NSString*)convertFileSizeStringFromHeader:(NSString*)fileSizeFromHeader;
{
    NSString* returnFileSizeString;
    
    float fileSizeKb = [fileSizeFromHeader floatValue];
    fileSizeKb = fileSizeKb / 1000;         // convert to KB
    
    if (fileSizeKb < 1000) {                // check if less than 1MB
        returnFileSizeString = [NSString stringWithFormat:@"%0.0f KB",fileSizeKb];
    } else {                                // but if greater than 1MB
        fileSizeKb = fileSizeKb / 1000;     // convert to MB
        returnFileSizeString = [NSString stringWithFormat:@"%0.2f MB",fileSizeKb];
    }
    
    return returnFileSizeString;
}

@end
