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

@interface TaskManager : NSObject

+ (instancetype)sharedManager;
@property (strong, nonatomic) TaskListObject *taskLists;

@end
