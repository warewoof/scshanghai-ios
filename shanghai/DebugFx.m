//
//  DebugFx.m
//  shanghai
//
//  Created by Frank Yin on 9/30/12.
//  Copyright (c) 2012 Warewoof. All rights reserved.
//

#import "DebugFx.h"

@implementation DebugFx

@synthesize name, runTime, startDate;

-(id) initWithName:(NSString *)_name {
    if ((self = [super init])) {
        self.name = _name;
        runTime = 0;
    }
    return self;
}

-(void) start {
    self.startDate = [NSDate date];
}

-(void) stop {
    runTime += -[startDate timeIntervalSinceNow];
}

-(void) stats {
    DLog(@"%@ finished in %f seconds", name, runTime);
}

@end
