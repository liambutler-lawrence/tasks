//
//  TaskManager.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

@import Foundation;
#import "Task.h"

typedef NSMutableArray<Task *> TaskList;
typedef NSMutableDictionary<NSString *, TaskList *> TaskListObject;

extern NSString *const ALL_TASKS;

@interface TaskManager : NSObject

// Returns singleton instance
// Always use the singleton instance; directly initializing an instance of this class might result in undefined behavior
+ (instancetype)sharedManager;

// Returns the task list with specified title; nil if a task list with the specified title could not be found
// Passing ALL_TASKS for title will return a TaskList containing every task stored in a task list
- (TaskList *)taskListWithTitle: (NSString *)title;

// Adds a task list with specified title
// Returns YES if task list was successfully added; NO if a task list with the specified title already exists
// Passing ALL_TASKS for title will always fail
- (BOOL)addTaskListWithTitle: (NSString *)title;

// Adds a task to the task list with specified title
// Returns YES if task was successfully added; NO if a task list with the specified title could not be found
// Passing ALL_TASKS for title will always fail
- (BOOL)addTask: (Task *)task toTaskListWithTitle: (NSString *)title;

@end
