//
//  TaskManager.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "TaskManager.h"

NSString *const ALL_TASKS = @"All Tasks";
NSString *const NO_LIST = @"Uncategorized";

NSString *const TASK_LIST_TITLE = @"Task_List_Title";
NSString *const TASK_INDEX = @"Task_Index";

typedef NSMutableDictionary<NSString *, TaskList *> TaskListObject;


@interface TaskManager ()

@property (strong, nonatomic) TaskListObject *taskLists;

@end


@implementation TaskManager


#pragma mark - Singleton instance

- (instancetype)init {
    self.taskLists = [[TaskListObject alloc] init];
    self.taskLists[NO_LIST] = [[TaskList alloc] init];

    return self;
}

// Returns singleton instance
// Always use the singleton instance; directly initializing an instance of this class might result in undefined behavior
+ (instancetype)sharedManager {
    static TaskManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TaskManager alloc] init];
    });
    return manager;
}


#pragma mark - Querying task lists

// Returns an array containing the titles of every task list in alphabetical order
// ALL_TASKS is always included at beginning of returned array
- (NSArray<NSString *> *)taskListTitles {
    NSMutableArray<NSString *> *titles = [self.taskLists.allKeys mutableCopy];
    
    [titles sortUsingSelector:@selector(caseInsensitiveCompare:)];
    [titles removeObject:NO_LIST];
    [titles insertObject:ALL_TASKS atIndex:0];
    
    return [titles copy];
}

// Returns an array containing the titles of every task list in alphabetical order
// NO_LIST is always included at end of returned array
// ALL_TASKS is never included
- (NSArray<NSString *> *)allTaskListTitles {
    NSMutableArray<NSString *> *titles = [[self taskListTitles] mutableCopy];
    
    [titles removeObject:ALL_TASKS];
    [titles insertObject:NO_LIST atIndex:titles.count];
    
    return [titles copy];
}

// Returns a dictionary containing the following keys/values, or nil if the specified task could not be found
//
//              key : object
//  TASK_LIST_TITLE : (NSString) the title of the task list containing the specified task;
//       TASK_INDEX : (NSNumber) the index of the specified task in the task list
//
// taskIndex paramter must be the index of a task in the TaskList returned by calling taskListWithTitle: and passing ALL_TASKS
// If any of the methods in "Manipulating task lists" were called after generating this TaskList, this method may return incorrect results
- (NSDictionary *)taskListTitleAndTaskIndexForAllTasksIndex: (NSInteger)taskIndex {
    
    NSMutableDictionary *taskInfo = [@{} mutableCopy];
    
    NSArray<NSString *> *titles = [self allTaskListTitles];
    NSInteger cumulativeTaskCount = 0;
    
    for (NSString *title in titles) {
        
        NSInteger listTaskCount = [self taskListWithTitle:title].count;
        
        if (cumulativeTaskCount + listTaskCount > taskIndex) {
            taskInfo[TASK_LIST_TITLE] = title;
            taskInfo[TASK_INDEX] = @(taskIndex - cumulativeTaskCount);
            return [taskInfo copy];
        }
        cumulativeTaskCount += listTaskCount;

    }
    return nil;
}

// Returns the task list with specified title; nil if a task list with the specified title could not be found
// Passing ALL_TASKS for title will return a TaskList containing every task (including uncategorized tasks)
// Passing NO_LIST for title will return a TaskList containing only uncategorized tasks
- (TaskList *)taskListWithTitle: (NSString *)title {
    
    if ([title isEqualToString: ALL_TASKS]) {
        
        TaskList *allTasks = [[TaskList alloc] init];
        NSArray<NSString *> *titles = [self allTaskListTitles];
        
        for (NSString *title in titles) {
            [allTasks addObjectsFromArray:[self taskListWithTitle:title]];
        }
        return allTasks;
        
    } else {
        return self.taskLists[title];
    }
}

#pragma mark - Manipulating task lists

// Removes the task list with specified title AND all tasks stored in that task list
// Returns YES if task list was successfully removed; NO if a task list with the specified title could not be found
// Passing ALL_TASKS or NO_LIST for title will always fail
- (BOOL)removeTaskListWithTitle: (NSString *)title {
    
    if ([title isEqualToString: ALL_TASKS] || [title isEqualToString: NO_LIST]) {
        return NO;
    } else {
        [self.taskLists removeObjectForKey:title];
        return YES;
    }
}

// Adds a task list with specified title
// Returns YES if task list was successfully added; NO if a task list with the specified title already exists
// Passing ALL_TASKS or NO_LIST for title will always fail
- (BOOL)addTaskListWithTitle: (NSString *)title {
    
    if ([title isEqualToString: ALL_TASKS] || [title isEqualToString: NO_LIST] || [self taskListWithTitle:title] != nil) {
        return NO;
    } else {
        self.taskLists[title] = [[TaskList alloc] init];
        return YES;
    }
}


// Removes a task at specified index from the task list with specified title
// Returns YES if task was successfully removed; NO if a task list with the specified title could not be found
// Passing NO_LIST for title will remove an uncategorized task
// Passing ALL_TASKS for title will always fail
- (BOOL)removeTaskAtIndex: (NSInteger)taskIndex fromTaskListWithTitle: (NSString *)title {
    
    if ([title isEqualToString: ALL_TASKS] || [self taskListWithTitle:title] == nil) {
        return NO;
    } else {
        [[self taskListWithTitle:title] removeObjectAtIndex:taskIndex];
        return YES;
    }
}

// Adds a task to the task list with specified title
// Returns YES if task was successfully added; NO if a task list with the specified title could not be found
// Passing NO_LIST for title will add an uncategorized task
// Passing ALL_TASKS for title will always fail
- (BOOL)addTask: (Task *)task toTaskListWithTitle: (NSString *)title {
    
    if ([title isEqualToString: ALL_TASKS] || [self taskListWithTitle:title] == nil) {
        return NO;
    } else {
        [[self taskListWithTitle:title] addObject:task];
        return YES;
    }
}


@end
