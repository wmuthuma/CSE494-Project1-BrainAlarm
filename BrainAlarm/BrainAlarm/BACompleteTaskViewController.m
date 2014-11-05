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
#import "BAJumpingJackTask.h"
#import "BAMathProblem.h"

@interface BACompleteTaskViewController ()
@property bool taskIsDone;
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property BAJumpingJackTask *jacksTask;
@property BAMathProblem *mathTask;
@property (weak, nonatomic) IBOutlet UITextField *mathCheckAnswerText;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UIButton *mathCheckAnswerButton;
- (IBAction)checkAnswer:(id)sender;
@end

@implementation BACompleteTaskViewController

NSTimer *infoUpdater;

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
    if([self.notification.alertBody containsString:@"Jumping Jacks"])
    {
        self.jacksTask = [BAJumpingJackTask sharedInstance];
        self.taskType = 0;
        self.taskLabel.text = @"10 Jumping Jacks";
        infoUpdater = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(UpdateInfo:) userInfo:Nil repeats:YES];
        
        self.mathCheckAnswerButton.hidden = YES;
        self.mathCheckAnswerButton.enabled = NO;
        self.mathCheckAnswerText.hidden = YES;
        self.mathCheckAnswerText.enabled = NO;
    }
    else
    {
        self.mathTask = [[BAMathProblem alloc] initGenerateProblem];
        self.taskType = 1;
        self.taskLabel.text = @"Do the problem!";
        
        self.infoLabel.text = [self.mathTask ToString];
        
    }
    self.taskIsDone = false;
    self.warningLabel.text = @"";
    
}

-(void)UpdateInfo:(NSTimer*)theTimer
{
    self.infoLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.jacksTask JacksDone] ];
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



-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    NSLog(@"Hi from back to alarm button");
    if([self.jacksTask JacksCompleted] || self.taskIsDone)
    {
        if ([infoUpdater isValid]) {
            [infoUpdater invalidate];
        }
        [self.jacksTask terminateJJTask];
        NSLog(@"Before deleting from list");
        //NSLog(@"Alert Body: %@", self.notification.alertBody);
        for(BAAlarmModel *a in [BATableViewController alarms])
        {
            if([a.alarmTime isEqual:self.notification.userInfo[@"Name"]])
            {
                [[BATableViewController alarms] removeObject:a];
                NSLog(@"Found object");
                break;
            }
        }
        
        //Should work need to test
        NSLog(@"Unsubscribe local notification for this alarm");
        
        NSArray *notificationList = [[UIApplication sharedApplication] scheduledLocalNotifications];
        
        //In case cleanup is necessary
        for(UILocalNotification *not in notificationList)
        {
            if([self.notification.userInfo[@"Name"] isEqual:not.fireDate])
            {
                NSLog(@"Found original notification and deleted it");
                [[UIApplication sharedApplication] cancelLocalNotification:not];
            }
        }
        
        [[UIApplication sharedApplication] cancelLocalNotification:self.notification];
        
        NSLog(@"Save NSCoding");
        
        [BATableViewController SaveAlarmList];
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }
    
    return NO;
}

- (IBAction)checkAnswer:(id)sender {
    
    int answer = [self.mathCheckAnswerText.text intValue];
    if([self.mathTask isAnswerCorrect:answer])
    {
        self.taskIsDone = YES;
        self.warningLabel.text = @"Correct!";
        self.mathCheckAnswerText.enabled = NO;
        self.mathCheckAnswerText.hidden = YES;
        self.mathCheckAnswerButton.enabled = NO;
        self.mathCheckAnswerButton.hidden = YES;
    }
    else{
        self.warningLabel.text = @"Incorrect Answer";
        self.mathCheckAnswerText.text = @"";
    }
    
}
@end
