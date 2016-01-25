//
//  TaskListTableViewController.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "TaskListTableViewController.h"

@implementation TaskListTableViewController

#pragma mark - Table View
#pragma mark Delegate
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
            textColor = [UIColor yellowColor];
            break;
        case TaskPriorityLow:
            textColor = [UIColor greenColor];
            break;
    }
    cell.textLabel.textColor = textColor;
    
    return cell;
}

@end
