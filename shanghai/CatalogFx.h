//
//  AppFx.h
//  shanghai
//
//  Created by Frank Yin on 10/14/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogFx : NSObject

+(NSString*) serverUrl;
+(NSString*) localCatalogFilePath;
+(NSString*) localZipFilePath;
+(NSString*) localDataDirectory;
+(NSString*) localDocumentsDirectory;
+(void) unzipToDocumentsDirectory;
+(BOOL)localCatalogShouldBeUpdated:(NSString*)serverLastMod ifFileNotFound:(BOOL)allowDownload;
+(NSString*)convertFileSizeStringFromHeader:(NSString*)fileSizeKb;
@end
