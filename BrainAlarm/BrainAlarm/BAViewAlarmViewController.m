//
//  BAViewAlarmViewController.m
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import "BAViewAlarmViewController.h"
#import "BATableViewController.h"
#import "BAAlarmModel.h"

@interface BAViewAlarmViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
- (IBAction)deleteAlarmButton:(id)sender;

@property BAAlarmModel *alarm;

@end

@implementation BAViewAlarmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get the alarm selected from the table
    self.alarm = [BATableViewController alarms][self.alarmIndex];
    
    //Show the user the alarm time
    self.datePicker.date = [self.alarm alarmTime];
    
    NSLog(@"AlarmType: %d", [self.alarm type]);
    
    //Show the user the task type
    switch([self.alarm type])
    {
        case JJ:
            self.taskLabel.text = @"Jumping Jacks";
            break;
        case Math:
            self.taskLabel.text = @"Math";
            break;
    }
}

//If the user wants to delete the alarm
- (IBAction)deleteAlarmButton:(id)sender
{
    //Find and remove the alarm from the alarm list
    for(BAAlarmModel *a in [BATableViewController alarms])
    {
        if([self.alarm isEqual:a])
        {
            [[BATableViewController alarms] removeObject:a];
            break;
        }
    }
    
    [BATableViewController SaveAlarmList];
    
    //Remove notifications pertaining to the alarm
    NSArray *notificationList = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for(UILocalNotification *not in notificationList)
    {
        if([self.alarm.alarmTime isEqual:not.fireDate])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:not];
        }
    }
    
    //Go back to the table of alarms
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
