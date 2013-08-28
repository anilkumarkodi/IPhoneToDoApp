//
//  ViewController.m
//  ToDoApp
//
//  Created by gauravm on 22/08/13.
//  Copyright (c) 2013 thoughtworks. All rights reserved.
//

#import "ViewController.h"
#import "TaskDataModel.h"
#import "TableCell.h"
#import "TaskRow.h"
#import "CalenderViewController.h"
#import "SubTaskController.h"
@interface ViewController ()

@end

@implementation ViewController
NSMutableArray *tableData;
@synthesize enterTaskTextField;
@synthesize tableView;
@synthesize actualDate;

- (void)viewDidLoad
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setDate:)
                                                 name:@"selectedDate" object:nil];

    [super viewDidLoad];
    TaskDataModel *taskData = [[TaskDataModel alloc]init];
    tableData = [[NSMutableArray alloc] init];
    tableData = [taskData getData:tableData];
    actualDate = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                dateStyle:NSDateFormatterShortStyle
                                                timeStyle:NSDateFormatterShortStyle];

    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(handleSwipeFrom:)];
    [gesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [tableView addGestureRecognizer:gesture];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    NSLog(@"%d",swipedIndexPath.row);
    TaskRow *row = [tableData objectAtIndex:swipedIndexPath.row];
    NSLog(@"%@",row.todoTitle);
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableCell";
    TableCell *cell = (TableCell*)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    TaskRow *row = (TaskRow*)[tableData objectAtIndex:indexPath.row];
    cell.dateLabelCell.text = row.date;
    cell.titleLabelCell.text = row.todoTitle;
    return cell;
}
-(void)setDate:(NSNotification*) notification{
     actualDate = [notification object];
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (editingStyle == UITableViewCellEditingStyleDelete){
            
            TaskDataModel *task1 = [[TaskDataModel alloc]init];
            TaskRow *row = [tableData objectAtIndex:indexPath.row];
            [tableData removeObjectAtIndex:indexPath.row];
            [task1 deleteRow:row.todoId];
            [tableView reloadData];
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert){
            [tableData insertObject:@"Tutorial" atIndex:[tableData count]];
            [tableView reloadData];
        }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    TaskDataModel *taskData = [[TaskDataModel alloc]init];
    TaskRow *taskRow=[[TaskRow alloc]init];
    [taskData inserttitle:textField.text anddate:actualDate];
    taskRow = [taskData getMaxRecord:taskRow];
    [tableData insertObject:taskRow atIndex:0];
    [tableView reloadData];
    [textField resignFirstResponder];
    self.enterTaskTextField.text = nil;
    return YES;
}

-(IBAction)loadCalender:(id)sender
{
    CalenderViewController *cvc = [[CalenderViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    SubTaskController *subTaskController=[[SubTaskController alloc] init];
    [self.navigationController pushViewController:subTaskController animated:YES];
    TableCell *t = (TableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    subTaskController.titleLabel.text = t.titleLabelCell.text;
}

@end
