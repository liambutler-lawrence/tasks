//
//  TaskPlainTextDataSource.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/27/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

@import Foundation;
#import "TaskManagerDataSource.h"

@interface TaskPlainTextDataSource : NSObject <TaskManagerDataSource>

- (instancetype)init __attribute__((unavailable("Use initWithPlainTextURL: instead.")));
- (instancetype)initWithPlainTextURL: (NSURL *)url;


#pragma mark - Task Manager Data Source

- (TaskListObject *)readTasks;

@end
