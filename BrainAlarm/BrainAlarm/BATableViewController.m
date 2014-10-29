//
//  BATableViewController.m
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import "BATableViewController.h"
#import "BAViewAlarmViewController.h"
#import "BAAlarmModel.h"

@interface BATableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BATableViewController

static NSMutableArray *alarmList;
+ (NSMutableArray *)alarms
{
    if (!alarmList)
        alarmList = [[NSMutableArray alloc] init];
    
    return alarmList;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    NSLog(@"Reload");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // first we create a button and set it's properties
    //UIBarButtonItem *myButton = [[UIBarButtonItem alloc]init];
    //myButton.action = @selector(doTheThing);
    //myButton.title = @"+";
    //myButton.target = self;
    
    // then we add the button to the navigation bar
    //self.navigationItem.rightBarButtonItem = myButton;
    
}

- (void) doTheThing {
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Yo%d", alarmList.count);
    return alarmList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    

    formatter.dateFormat = @"hh:mm a EEE, MMM dd";
    
   
    
    NSString *formattedDate = [formatter stringFromDate:[alarmList[indexPath.row] alarmTime]
];
    
    
    cell.textLabel.text = formattedDate;
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"tableViewSegue"]) {
        UITableViewCell *cell = sender;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        BAViewAlarmViewController *dest = [segue destinationViewController];
        
        dest.alarmIndex = indexPath.row;
        
        NSLog(@"Segue TableView: %d", dest.alarmIndex);
        
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
