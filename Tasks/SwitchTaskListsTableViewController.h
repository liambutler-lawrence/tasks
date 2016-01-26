//
//  SwitchTaskListsTableViewController.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/26/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

@import UIKit;
#import "TaskManager.h"

@protocol SwitchTaskListsTableViewControllerDelegate <NSObject>

@required
@property (strong, nonatomic) NSString *taskListTitle;

@end

@interface SwitchTaskListsTableViewController : UITableViewController

// Must be set before the table view loads
// Used to visually identify the currently selected task list & record the new selection (if any)
@property (strong, nonatomic) UIViewController<SwitchTaskListsTableViewControllerDelegate> *delegate;

@end
