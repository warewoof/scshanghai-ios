//
//  DebugFx.h
//  shanghai
//
//  Created by Frank Yin on 9/30/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugFx : NSObject {
    NSString* name;
    NSTimeInterval runTime;
    NSDate* startDate;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, readonly) NSTimeInterval runTime;
@property (nonatomic, retain) NSDate* startDate;

-(id) initWithName:(NSString*) name;
-(void) start;
-(void) stop;
-(void) stats;

@end
