//
//  TaskListTableViewController.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "TaskListTableViewController.h"

@implementation TaskListTableViewController

#pragma mark - View Controller

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    // Bug in iOS (unresolved as of 9.2): does not reliably deselect rows when returning to table view from 'pushed' view controller (specifically when swiping slowly from left edge)
    // Workaround: manually deselect any row still selected before view appears
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.tableView setEditing:NO animated:YES];
}


#pragma mark - Task List Manipulation Methods

- (void)deleteTaskAtIndexPath: (NSIndexPath *)indexPath {
    
    NSString *taskListTitle;
    NSInteger taskIndex;
    
    if (self.taskListTitle == ALL_TASKS) {
        NSDictionary *taskInfo = [[TaskManager sharedManager] taskListTitleAndTaskIndexForAllTasksIndex:indexPath.row];
        taskListTitle = taskInfo[TASK_LIST_TITLE];
        taskIndex = [(NSNumber *)taskInfo[TASK_INDEX] integerValue];
    } else {
        taskListTitle = self.taskListTitle;
        taskIndex = indexPath.row;
    }
    
    [[TaskManager sharedManager] removeTaskAtIndex:taskIndex fromTaskListWithTitle:taskListTitle];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Table View

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TaskViewController *detailViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithClassIdentifier:[TaskViewController class]];
    
    if (self.taskListTitle == ALL_TASKS) {
        NSDictionary *taskInfo = [[TaskManager sharedManager] taskListTitleAndTaskIndexForAllTasksIndex:indexPath.row];
        detailViewController.taskListTitle = taskInfo[TASK_LIST_TITLE];
        detailViewController.taskIndex = [(NSNumber *)taskInfo[TASK_INDEX] integerValue];
    } else {
        detailViewController.taskListTitle = self.taskListTitle;
        detailViewController.taskIndex = indexPath.row;
    }


    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; // All tasks are presented in a single section (priority is distinguished by text color)
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger taskCount = [[TaskManager sharedManager] taskListWithTitle:self.taskListTitle].count;
    return taskCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reusableCellIdentifier = @"TaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier forIndexPath:indexPath];
    
    TaskList *taskList = [[TaskManager sharedManager] taskListWithTitle:self.taskListTitle];
    Task *task = taskList[indexPath.row];
    
    cell.textLabel.text = task.name;

    UIColor *textColor;
    switch (task.priority) {
        case TaskPriorityHigh:
            textColor = [UIColor redColor];
            break;
        case TaskPriorityMedium:
            textColor = [UIColor orangeColor];
            break;
        case TaskPriorityLow:
            textColor = [UIColor brownColor];
            break;
    }
    cell.accessibilityValue = [NSString stringWithFormat:@"%ld", task.priority];
    cell.textLabel.textColor = textColor;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteTaskAtIndexPath:indexPath];
    }
}

@end
