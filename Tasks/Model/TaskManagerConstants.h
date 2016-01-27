//
//  TaskManagerConstants.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/27/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "Task.h"

#pragma mark - typedefs

typedef NSMutableArray<Task *> TaskList;
typedef NSMutableDictionary<NSString *, TaskList *> TaskListObject;


#pragma mark - constants

extern NSString *const ALL_TASKS;
extern NSString *const NO_LIST;

extern NSString *const TASK_LIST_TITLE;
extern NSString *const TASK_INDEX;