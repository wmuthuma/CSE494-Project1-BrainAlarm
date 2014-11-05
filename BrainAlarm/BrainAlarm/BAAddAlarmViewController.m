//
//  BAAddAlarmViewController.m
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import "BAAddAlarmViewController.h"
#import "BAAlarmModel.h"
#import "BATableViewController.h"

@interface BAAddAlarmViewController ()

//properties for UI elements
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

//array for choices (source for picker view)
@property NSArray *taskChoices;

@end

@implementation BAAddAlarmViewController

//picker view methods
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.taskChoices.count;
}

-(NSString* )pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.taskChoices[row];
}


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
    //initialize the array for picker view choices
    self.taskChoices = [[NSArray alloc] initWithObjects:@"Jumping Jacks", @"Math", nil];
}

//add a new alarm button
- (IBAction)addAlarmAction:(id)sender
{
    //instantiate a new alarm object
    BAAlarmModel *newAlarm = [[BAAlarmModel alloc]init];
    
    //set the new alarm time to right now
    newAlarm.alarmTime = self.datePicker.date;
    
    //set the type to whatever the picker view says
    newAlarm.type = (int) [self.pickerView selectedRowInComponent:0];
    NSLog(@"Add New: %d", newAlarm.type);
    
    
    //add the new alarm to the list
    [[BATableViewController alarms] addObject: newAlarm];
    
    //instantiate the local notification
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    //change all of the parameters for the notification
    notification.fireDate = newAlarm.alarmTime;
    notification.repeatInterval = NSCalendarUnitMinute;
    //Need to test
    notification.soundName = @"Alarm.mp3";
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:newAlarm.alarmTime forKey:@"Name"];
    notification.userInfo = infoDict;
    NSString *alarmString;
    
    //depending on which type, change the type of task to be done
    switch(newAlarm.type)
    {
        case Math:
            alarmString = @"Math task to be done!";
            break;
        case JJ:
            alarmString = @"Jumping Jacks to be done!";
            break;
        default: ;
    }
    
    
    //change the alert body of the notification
    notification.alertBody = alarmString;
    
    
    //subscribe the notification
    [[UIApplication sharedApplication] scheduleLocalNotification: notification];
    
    //[notification release];
    
    //save the alarm list using nscoding
    [BATableViewController SaveAlarmList];
    
    //pop back to tableviewcontroller
    [self.navigationController popViewControllerAnimated:YES];
    
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

@end
