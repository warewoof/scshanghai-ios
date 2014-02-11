//
//  Global.h
//  shanghai
//
//  Created by Frank Yin on 10/26/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
    #define DLog(f, ...) NSLog(f, ##__VA_ARGS__)
#else
    #define DLog(f, ...)
#endif


#define modeServerUrl @"http://www.warewoof.com/scs/dev/scs.zip"
//#define modeServerUrl @"http://www.warewoof.com/scs/release/scs.zip"


#define internalCatalogDate @"20121129"

#define rootCatalogParent @"Simple City Shanghai"
#define rootCatalogChild @"Shanghai"
//#define rootCatalogParent @"MSH Demo"
//#define rootCatalogChild @"Direct Billing"

/*
*   - make sure to check server address and catalog settings here
*   - check catalog.xml in resources, does it contain the latest version with date stamp?
*   - update version number in Manifest
*/