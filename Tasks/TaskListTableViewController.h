//
//  TaskListTableViewController.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

@import UIKit;

#import "TaskViewController.h"

@interface TaskListTableViewController : UITableViewController

// Must be set before the table view loads
// Used to query the TaskManager for the tasks to display
@property (strong, nonatomic) NSString *taskListTitle;

@end
