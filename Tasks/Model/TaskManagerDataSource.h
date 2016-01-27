//
//  TaskManagerDataSource.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/27/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

@import Foundation;
#import "TaskManagerConstants.h"

@protocol TaskManagerDataSource <NSObject>

@required
- (TaskListObject *)readTasks;

@optional
- (BOOL)writeTasks: (TaskListObject *)tasks;

@end
