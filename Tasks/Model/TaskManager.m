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


#pragma mark - Manipulating task lists

// Returns the task list with specified title; nil if a task list with the specified title could not be found
// Passing ALL_TASKS for title will return a TaskList containing every task (including uncategorized tasks)
// Passing NO_LIST for title will always fail
- (TaskList *)taskListWithTitle: (NSString *)title {
    
    if ([title isEqualToString: NO_LIST]) {
        return nil;
        
    } else if ([title isEqualToString: ALL_TASKS]) {
        TaskList *allTasks = [[TaskList alloc] init];
        [self.taskLists enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull title, TaskList * _Nonnull tasks, BOOL * _Nonnull stop) {
            [allTasks addObjectsFromArray:tasks];
        }];
        return allTasks;
        
    } else {
        return self.taskLists[title];
    }
}

// Adds a task list with specified title
// Returns YES if task list was successfully added; NO if a task list with the specified title already exists
// Passing ALL_TASKS or NO_LIST for title will always fail
- (BOOL)addTaskListWithTitle: (NSString *)title {
    
    if ([title isEqualToString: ALL_TASKS] || [title isEqualToString: NO_LIST] ||[self taskListWithTitle:title] != nil) {
        return NO;
    } else {
        self.taskLists[title] = [[TaskList alloc] init];
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
