//
//  TaskPlainTextDataSource.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/27/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "TaskPlainTextDataSource.h"


@interface TaskPlainTextDataSource ()

@property (strong, nonatomic) NSURL *plainTextURL;

@end


@implementation TaskPlainTextDataSource

- (instancetype)initWithPlainTextURL: (NSURL *)url {
    self.plainTextURL = url;
    return self;
}


#pragma mark - Task Manager Data Source

- (TaskListObject *)readTasks {
    
    // get array containing each line in text file as NSString
    NSError *dataReadError;
    NSString *taskDataString = [[NSString alloc] initWithContentsOfURL:self.plainTextURL encoding:NSUTF8StringEncoding error:&dataReadError];
    if (taskDataString == nil) {
        NSLog(@"Failed to read tasks from text file at URL: %@. Error: %@", self.plainTextURL, dataReadError);
        return nil;
    }
    
    NSArray<NSString *> *taskDataLines = [taskDataString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    
    // create collection objects to hold listdata while iterating
    TaskListObject *allTaskLists = [[TaskListObject alloc] init];
    
    NSString *currentTaskListTitle = NO_LIST;
    TaskList *currentTaskList = [[TaskList alloc] init];
    
    
    // for each line, split into NSStrings around '*' delimiter character
    for (NSString *taskDataLine in taskDataLines) {
        NSArray<NSString *> *taskDataLineComponents = [taskDataLine componentsSeparatedByString:@"*"];
        
        if (taskDataLineComponents.count == 2) {
            
            // lines denoting list titles begin with a '*' character
            if ([taskDataLineComponents.firstObject isEqualToString: @""]) {
                
                // save current task list to list object
                [allTaskLists setObject:currentTaskList forKey:currentTaskListTitle];
                
                // reset current task list using title from current line
                currentTaskListTitle = taskDataLineComponents.lastObject;
                currentTaskList = [[TaskList alloc] init];
                
            // lines denoting tasks contain the task name before a '*' character and the task priority (in range 0..2) after
            } else {
                
                // save task to current task list using name & priority from current line
                Task *currentTask = [[Task alloc] initWithName:taskDataLineComponents.firstObject priority:taskDataLineComponents.lastObject.integerValue];
                [currentTaskList addObject:currentTask];
            }
            
        // lines denoting tasks can optionally leave out the trailing '*' character & task priority
        } else if (taskDataLineComponents.count == 1 && ![taskDataLineComponents.firstObject isEqualToString: @""]) {
            
            // save task to current task list using name from current line & default priority
            Task *currentTask = [[Task alloc] initWithName:taskDataLineComponents.firstObject priority:TaskPriorityMedium];
            [currentTaskList addObject:currentTask];
        }
    }
    
    // save last task list to list object before returning
    [allTaskLists setObject:currentTaskList forKey:currentTaskListTitle];
    return allTaskLists;
}

@end
