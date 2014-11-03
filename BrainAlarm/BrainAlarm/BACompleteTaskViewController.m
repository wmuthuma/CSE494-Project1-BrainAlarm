//
//  BACompleteTaskViewController.m
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import "BACompleteTaskViewController.h"
#import "BATableViewController.h"
#import "BAAlarmModel.h"

@interface BACompleteTaskViewController ()
- (IBAction)backToAlarmsButton:(id)sender;
@property bool taskIsDone;
@end

@implementation BACompleteTaskViewController


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
    self.taskIsDone = true;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Do later!!
- (IBAction)backToAlarmsButton:(id)sender
{
    if(self.taskIsDone)
    {
        NSLog(@"Before deleting from list");
        NSLog(@"FireDate: %@", self.date);
        //NSLog(@"Alert Body: %@", self.notification.alertBody);
        for(BAAlarmModel *a in [BATableViewController alarms])
        {
            if([a.alarmTime isEqual:self.notification.userInfo[@"Name"]])
            {
                [[BATableViewController alarms] removeObject:a];
                NSLog(@"Found object");
                break;
            }
            NSLog(@"Time: %@", [a alarmTime]);
        }
        
        //Should work need to test
        NSLog(@"Unsubscribe local notification for this alarm");
        
        [[UIApplication sharedApplication] cancelLocalNotification:self.notification];
        
        NSArray *notificationList = [[UIApplication sharedApplication] scheduledLocalNotifications];
        
        for(UILocalNotification *not in notificationList)
        {
            if([self.notification.userInfo[@"Name"] isEqual:not.fireDate])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:not];
            }
        }
        
        NSLog(@"Save NSCoding");
        
        [BATableViewController SaveAlarmList];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}
@end
