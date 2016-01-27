//
//  Task.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "Task.h"


TaskPriority const TASK_PRIORITY_DEFAULT = TaskPriorityMedium;


@implementation Task

- (instancetype)initWithName: (NSString *)name priority: (TaskPriority)priority {
    self.name = name;
    self.priority = priority;
    return self;
}

@end
