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


extern NSInteger const NEW_TASK;


@interface TaskViewController : UIViewController <UITextFieldDelegate>

// Both of these properties must be set before the table view loads
// Setting taskListTitle to NEW_TASK enables 'create' mode (using the specified task list)
// Otherwise, 'edit' mode is enabled and these properties are used to query the TaskManager for the task to display
@property (strong, nonatomic) NSString *taskListTitle;
@property (nonatomic) NSInteger taskIndex;

@end
