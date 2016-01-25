//
//  TaskManager.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "TaskManager.h"

NSString *const ALL_TASKS = @"define_all_tasks";


@interface TaskManager ()

@property (strong, nonatomic) TaskListObject *taskLists;

@end


@implementation TaskManager


#pragma mark - Singleton instance

- (instancetype)init {
    self.taskLists = [[TaskListObject alloc] init];
    return self;
}

+ (instancetype)sharedManager {
    static TaskManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TaskManager alloc] init];
    });
    return manager;
}


#pragma mark - Manipulating task lists

- (TaskList *)taskListWithTitle: (NSString *)title {
    
    if ([title isEqualToString: ALL_TASKS]) {
        TaskList *allTasks = [[TaskList alloc] init];
        [self.taskLists enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull title, TaskList * _Nonnull tasks, BOOL * _Nonnull stop) {
            [allTasks addObjectsFromArray:tasks];
        }];
        return allTasks;
    } else {
        return self.taskLists[title];
    }
}

- (BOOL)addTaskListWithTitle: (NSString *)title {
    
    if ([title isEqualToString: ALL_TASKS] || [self taskListWithTitle:title] != nil) {
        return NO;
    } else {
        self.taskLists[title] = [[TaskList alloc] init];
        return YES;
    }
}

- (BOOL)addTask: (Task *)task toTaskListWithTitle: (NSString *)title {
    
    if ([title isEqualToString: ALL_TASKS] || [self taskListWithTitle:title] == nil) {
        return NO;
    } else {
        [[self taskListWithTitle:title] addObject:task];
        return YES;
    }
}


@end
