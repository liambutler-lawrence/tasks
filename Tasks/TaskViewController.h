//
//  TaskViewController.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

@import UIKit;

#import "TaskManager.h"
#import "UIStoryboard+MainStoryboard.h"
#import "UIStoryboard+ClassIdentifier.h"


@interface TaskViewController : UIViewController

// If taskListTitle are not set before the table view loads, 'create' mode is enabled
// Otherwise, 'edit' mode is enabled and these properties are used to query the TaskManager for the task to display
@property (strong, nonatomic) NSString *taskListTitle;
@property (nonatomic) NSInteger taskIndex;

@end
