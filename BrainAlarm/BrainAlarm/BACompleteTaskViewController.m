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
@import AudioToolbox;
@import AVFoundation;

@interface BACompleteTaskViewController ()
@property bool taskIsDone;
//What kind of task
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
//Info pertaining to task
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property BAJumpingJackTask *jacksTask;
@property BAMathProblem *mathTask;
//For math task
@property (weak, nonatomic) IBOutlet UITextField *mathCheckAnswerText;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UIButton *mathCheckAnswerButton;
- (IBAction)checkAnswer:(id)sender;

@property (strong, nonatomic) AVAudioPlayer *click;
@end

@implementation BACompleteTaskViewController

NSTimer *infoUpdater;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Continue alarm sound
    // Construct URL to sound file
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Alarm" ofType:@"mp3"];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    NSError *error;
    self.click = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    if(error)
    {
        NSLog(@"%@", error);
    }
    else
    {
        self.click.numberOfLoops = 3;
        self.click.volume = 1.0;
        [self.click play];
    }
    
    //JJ task
    if([self.notification.alertBody containsString:@"Jumping Jacks"])
    {
        self.jacksTask = [BAJumpingJackTask sharedInstance];
        self.taskType = 0;
        self.taskLabel.text = @"10 Jumping Jacks";
        //Used to repeatedly fetch how many JJs have been done
        infoUpdater = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(UpdateInfo:) userInfo:Nil repeats:YES];
        
        //Hide stuff related to the math task.
        self.mathCheckAnswerButton.hidden = YES;
        self.mathCheckAnswerButton.enabled = NO;
        self.mathCheckAnswerText.hidden = YES;
        self.mathCheckAnswerText.enabled = NO;
        
        return;
    }
    
    
    //Math task
    else if([self.notification.alertBody containsString:@"Deactivated"])
    {
        self.mathTask = [[BAMathProblem alloc] initGenerateProblem];
        self.taskType = 2;
        self.taskLabel.text = @"Do the problem!";
        
        self.infoLabel.text = [self.mathTask ToString];
        
        //No JJ task
        self.jacksTask = nil;
        return;
        
    }
    
    
    //Kill Me Task
    else if([self.notification.alertBody containsString:@"Tap me 10 times to stop"])
    {
        self.taskLabel.text = @"Swipe Me  10 times Please :)";
        self.taskType = 1;
        
        
        UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(0,150,100,100)];
        dot.image=[UIImage imageNamed:@"porkypig.jpg"];
        [self.view addSubview:dot];
        
        [dot setUserInteractionEnabled:YES];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        
        // Setting the swipe direction.
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        
        // Adding the swipe gesture on image view
        [dot addGestureRecognizer:swipeRight];
        

        
        
        
        //Hide stuff related to the math task.
        self.mathCheckAnswerButton.hidden = YES;
        self.mathCheckAnswerButton.enabled = NO;
        self.mathCheckAnswerText.hidden = YES;
        self.mathCheckAnswerText.enabled = NO;
        
        //No JJ task
        self.jacksTask = nil;
        self.taskIsDone = YES;
        
        
        
        return;
    }
    
    
    
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    

    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        self.taskIsDone = YES;
        
        self.taskLabel.text = @"Task Completed";
        self.jacksTask = nil;
        
        [self.click stop];
       
        
    }
    
}

//Allow the keyboard to be hidden
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//Get the number of JJs done
-(void)UpdateInfo:(NSTimer*)theTimer
{
    self.infoLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.jacksTask JacksDone] ];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    NSLog(@"Hi from back to alarm button");
    //If the task was completed
    if([self.jacksTask JacksCompleted] || self.taskIsDone)
    {
        //Stop alarm
        [self.click stop];
        //Stop getting the number of JJs done if that was the task
        if ([infoUpdater isValid]) {
            [infoUpdater invalidate];
        }
        
        //Terminate the JJ task if it was the task
        if(self.jacksTask != nil)
        {
            [self.jacksTask terminateJJTask];
        }
        
        
        NSLog(@"Before deleting from list");
        //Remove the alarm from the list
        for(BAAlarmModel *a in [BATableViewController alarms])
        {
            if([a.alarmTime isEqual:self.notification.userInfo[@"Name"]])
            {
                [[BATableViewController alarms] removeObject:a];
                NSLog(@"Found object");
                break;
            }
        }

        //Remove notifications pertaining to the alarm
        NSLog(@"Unsubscribe local notification for this alarm");
        
        NSArray *notificationList = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for(UILocalNotification *not in notificationList)
        {
            if([self.notification.userInfo[@"Name"] isEqual:not.fireDate])
            {
                NSLog(@"Found original notification and deleted it");
                [[UIApplication sharedApplication] cancelLocalNotification:not];
            }
        }
        
        [[UIApplication sharedApplication] cancelLocalNotification:self.notification];
        
        //Save the alarm list
        NSLog(@"Save NSCoding");
        
        [BATableViewController SaveAlarmList];
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }
    
    return NO;
}

//Check if the answer to the math problem is correct, if that was the task
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
