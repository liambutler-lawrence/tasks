//
//  Task.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, TaskPriority) {
    TaskPriorityLow,
    TaskPriorityMedium,
    TaskPriorityHigh
};

@interface Task : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) TaskPriority priority;

- (instancetype)init __attribute__((unavailable("Use initWithName:priority: instead.")));
- (instancetype)initWithName: (NSString *)name priority: (TaskPriority)priority;

@end
