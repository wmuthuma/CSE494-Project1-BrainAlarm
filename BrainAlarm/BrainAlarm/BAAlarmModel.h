//
//  BAAlarmModel.h
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAAlarmModel : NSObject

typedef enum
{
    JJ,
    Math
} TaskType;

typedef enum
{
    Sun,
    Mon,
    Tue,
    Wed,
    Thu,
    Fri,
    Sat
   
} Days;

@property NSDate *alarmTime;
@property TaskType type;
//@property NSArray *daysActive;




@end
