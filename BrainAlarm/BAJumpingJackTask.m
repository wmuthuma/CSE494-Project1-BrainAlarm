//
//  BAJumpingJackTask.m
//  BrainAlarm
//
//  Created by Buv Sethia on 11/4/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import "BAJumpingJackTask.h"
@import CoreMotion;

@interface BAJumpingJackTask ()

// How often should we update our position and velocity?
@property (nonatomic,strong) NSTimer *accelerometerUpdate;

// This will allow us to read our accelerometer values
@property (nonatomic,strong) CMMotionManager *motionManager;
@property NSInteger numberOfJacks;
@property NSInteger jacksToComplete;

@end

@implementation BAJumpingJackTask

bool xOkay1;
bool xOkay2;
bool yOkay;
bool zOkay;

static BAJumpingJackTask *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (BAJumpingJackTask *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        //create an accelerometer manager
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = .1;
        [self.motionManager startAccelerometerUpdates];
        self.accelerometerUpdate = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(update:) userInfo:Nil repeats:YES];
        self.numberOfJacks = 0;
        self.jacksToComplete = 5;
        xOkay1 = false;
        xOkay2 = false;
        yOkay = false;
        zOkay = false;
    }
    
    return self;
}

-(void)update:(NSTimer *)theTimer
{
    // get the current accelerometer data
    CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
    
    if(ABS(accelerometerData.acceleration.x) >= .8)
    {
        xOkay1 = true;
    }
    if(ABS(accelerometerData.acceleration.x) <= .1 && xOkay1)
    {
        xOkay2 = true;
    }
    if (ABS(accelerometerData.acceleration.y) >= 1.5)
    {
        yOkay = true;
    }
    if (ABS(accelerometerData.acceleration.z) >= .5)
    {
        zOkay = true;
    }
    
    if(xOkay1 && xOkay2 && yOkay && zOkay)
    {
        self.numberOfJacks++;
        xOkay1 = false;
        xOkay2 = false;
        yOkay = false;
        zOkay = false;
    }
    
}

-(void)terminateJJTask
{
    [self.motionManager stopAccelerometerUpdates];
    self.numberOfJacks = 0;
    xOkay1 = false;
    xOkay2 = false;
    yOkay = false;
    zOkay = false;
}

-(bool)JacksCompleted
{
    return (int) self.numberOfJacks  == (int) self.jacksToComplete;
}

-(NSInteger)JacksDone
{
    return self.numberOfJacks;
}

@end
