//
//  TaskManager.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

@import Foundation;
#import "Task.h"
#import "TaskManagerDataSource.h"
#import "TaskManagerConstants.h"

@interface TaskManager : NSObject


#pragma mark - Singleton instance

// Returns singleton instance
+ (instancetype)sharedManager;


#pragma mark - Querying task lists

// Returns an array containing the titles of every task list in alphabetical order
// ALL_TASKS is always included at beginning of returned array
- (NSArray<NSString *> *)taskListTitles;

// Returns a dictionary containing the following keys/values, or nil if the specified task could not be found
//
//              key : object
//  TASK_LIST_TITLE : (NSString) the title of the task list containing the specified task;
//       TASK_INDEX : (NSNumber) the index of the specified task in the task list
//
// taskIndex paramter must be the index of a task in the TaskList returned by calling taskListWithTitle: and passing ALL_TASKS
// If any of the methods in "Manipulating task lists" were called after generating this TaskList, this method may return incorrect results
- (NSDictionary *)taskListTitleAndTaskIndexForAllTasksIndex: (NSInteger)taskIndex;

// Returns the task list with specified title; nil if a task list with the specified title could not be found
// Passing ALL_TASKS for title will return a TaskList containing every task (including uncategorized tasks)
// Passing NO_LIST for title will return a TaskList containing only uncategorized tasks
- (TaskList *)taskListWithTitle: (NSString *)title;


#pragma mark - Manipulating task lists

// Removes the task list with specified title AND all tasks stored in that task list
// Returns YES if task list was successfully removed; NO if a task list with the specified title could not be found
// Passing ALL_TASKS or NO_LIST for title will always fail
- (BOOL)removeTaskListWithTitle: (NSString *)title;

// Adds a task list with specified title
// Returns YES if task list was successfully added; NO if a task list with the specified title already exists
// Passing ALL_TASKS or NO_LIST for title will always fail
- (BOOL)addTaskListWithTitle: (NSString *)title;


// Removes a task at specified index from the task list with specified title
// Returns YES if task was successfully removed; NO if a task list with the specified title could not be found
// Passing NO_LIST for title will remove an uncategorized task
// Passing ALL_TASKS for title will always fail
- (BOOL)removeTaskAtIndex: (NSInteger)taskIndex fromTaskListWithTitle: (NSString *)title;

// Adds a task to the task list with specified title
// Returns YES if task was successfully added; NO if a task list with the specified title could not be found
// Passing NO_LIST for title will add an uncategorized task
// Passing ALL_TASKS for title will always fail
- (BOOL)addTask: (Task *)task toTaskListWithTitle: (NSString *)title;


// "Batch import" task lists by passing an object that conforms to the TaskManagerDataSource protocol
// If a specified task list already exists, its tasks are added to the existing list
// Type-safe: invalid lists, lists with invalid keys (including ALL_LISTS), and invalid tasks are ignored
- (void)addTasksFromDataSource: (NSObject <TaskManagerDataSource> *)dataSource;
    
// "Batch save" task lists by passing an object that conforms to the TaskManagerDataSource protocol
// Returns YES if data source supports write operations; NO if unsupported
- (BOOL)saveTasksToDataSource: (NSObject <TaskManagerDataSource> *)dataSource;

@end
