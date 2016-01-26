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

extern NSString *const ALL_TASKS;
extern NSString *const NO_LIST;


@interface TaskManager : NSObject


#pragma mark - Singleton instance

// Returns singleton instance
// Always use the singleton instance; directly initializing an instance of this class might result in undefined behavior
+ (instancetype)sharedManager;


#pragma mark - Querying task lists

// Returns an array containing the titles of every task list in alphabetical order
// ALL_TASKS is always included in returned array at index 0
- (NSArray<NSString *> *)taskListTitles;

// Returns the task list with specified title; nil if a task list with the specified title could not be found
// Passing ALL_TASKS for title will return a TaskList containing every task (including uncategorized tasks)
// Passing NO_LIST for title will return a TaskList containing only uncategorized tasks
- (TaskList *)taskListWithTitle: (NSString *)title;


#pragma mark - Manipulating task lists

// Removes the task list with specified title AND all tasks stored in that task list.
// Returns YES if task list was successfully removed; NO if a task list with the specified title could not be found
// Passing ALL_TASKS or NO_LIST for title will always fail
- (BOOL)removeTaskListWithTitle: (NSString *)title;

// Adds a task list with specified title
// Returns YES if task list was successfully added; NO if a task list with the specified title already exists
// Passing ALL_TASKS or NO_LIST for title will always fail
- (BOOL)addTaskListWithTitle: (NSString *)title;

// Adds a task to the task list with specified title
// Returns YES if task was successfully added; NO if a task list with the specified title could not be found
// Passing NO_LIST for title will add an uncategorized task
// Passing ALL_TASKS for title will always fail
- (BOOL)addTask: (Task *)task toTaskListWithTitle: (NSString *)title;

@end
