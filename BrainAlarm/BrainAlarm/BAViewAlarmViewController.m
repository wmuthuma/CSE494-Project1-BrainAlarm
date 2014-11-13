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

@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
- (IBAction)deleteAlarmButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmEndLabel;

@property BAAlarmModel *alarm;

@end

@implementation BAViewAlarmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get the alarm selected from the table
    self.alarm = [BATableViewController alarms][self.alarmIndex];
    
    //Show the user the alarm time
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setTimeStyle:NSDateFormatterMediumStyle];
    NSString *formattedAlarm = [dateFormat stringFromDate:self.alarm.alarmTime];
    self.alarmEndLabel.text = formattedAlarm;
    
    
    // Real time countdown until alarm
    NSDate *alarmDate = [self.alarm alarmTime];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (true) {
            NSDate *now = [[NSDate alloc] init];
            NSTimeInterval diff = [alarmDate timeIntervalSinceDate:now];
            
            div_t hours_div = div(diff, 3600);
            int hours = hours_div.quot;
            
            div_t mins_div = div(hours_div.rem, 60);
            int mins = mins_div.quot;
            int secs = mins_div.rem;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countDownLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, mins, secs];
            });
            
            NSLog(@"%f", diff);
        }
    });

    //self.countDownLabel.text = formattedDate;
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
        case Kill:
            self.taskLabel.text = @"Kill";
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
