//
//  TaskPropertyListDataSource.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/27/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

@import Foundation;
#import "TaskManagerDataSource.h"

@interface TaskPropertyListDataSource : NSObject <TaskManagerDataSource>


// Returns singleton instance
+ (instancetype)defaultDataSource;

- (instancetype)init __attribute__((unavailable("Use initWithPropertyListURL: instead.")));
- (instancetype)initWithPropertyListURL: (NSURL *)url;


#pragma mark - Task Manager Data Source

- (TaskListObject *)readTasks;
- (BOOL)writeTasks: (TaskListObject *)tasks;


@end
