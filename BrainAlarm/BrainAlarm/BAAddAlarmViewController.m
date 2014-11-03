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
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property NSArray *taskChoices;

@end

@implementation BAAddAlarmViewController

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
    
    self.taskChoices = [[NSArray alloc] initWithObjects:@"Jumping Jacks", @"Math", nil];
}

- (IBAction)addAlarmAction:(id)sender
{
    BAAlarmModel *newAlarm = [[BAAlarmModel alloc]init];
    
    newAlarm.alarmTime = self.datePicker.date;
    
    newAlarm.type = [self.pickerView selectedRowInComponent:0];
    NSLog(@"Add New: %d", newAlarm.type);
    
    [[BATableViewController alarms] addObject: newAlarm];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = newAlarm.alarmTime;
    notification.repeatInterval = NSCalendarUnitMinute;
    //Need to test
    notification.soundName = @"Alarm.mp3";
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@", newAlarm.alarmTime] forKey:@"Name"];
    notification.userInfo = infoDict;
    NSString *alarmString;
    
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
    
    notification.alertBody = alarmString;
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification: notification];
    
    //[notification release];
    
    [BATableViewController SaveAlarmList];
    
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
