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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.alarm = [BATableViewController alarms][self.alarmIndex];
    self.datePicker.date = [self.alarm alarmTime];
    
    NSLog(@"AlarmType: %d", [self.alarm type]);
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)deleteAlarmButton:(id)sender
{
    for(BAAlarmModel *a in [BATableViewController alarms])
    {
        if([self.alarm isEqual:a])
        {
            [[BATableViewController alarms] removeObject:a];
            break;
        }
    }
    
    [BATableViewController SaveAlarmList];
    
    //should work test later
    NSArray *notificationList = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for(UILocalNotification *not in notificationList)
    {
        if([self.alarm.alarmTime isEqual:not.fireDate])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:not];
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
