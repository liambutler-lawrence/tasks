//
//  TaskPropertyListDataSource.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/27/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "TaskPropertyListDataSource.h"


@interface TaskPropertyListDataSource ()

@property (strong, nonatomic) NSURL *propertyListURL;

@end


@implementation TaskPropertyListDataSource


- (instancetype)initWithPropertyListURL: (NSURL *)url {
    
    self.propertyListURL = url;
    return self;
}


// Returns singleton instance
+ (instancetype)defaultDataSource {
    static TaskPropertyListDataSource *dataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSError *directoryQueryError;
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:&directoryQueryError];
        if (documentsDirectoryURL == nil) {
            NSLog(@"Failed to initialize shared TaskPersistenceManager. Error: %@", directoryQueryError);
            exit(EXIT_FAILURE);
        }
        
        NSURL *propertyListURL = [documentsDirectoryURL URLByAppendingPathComponent:@"saved_tasks.plist"];
        dataSource = [[TaskPropertyListDataSource alloc] initWithPropertyListURL:propertyListURL];
    });
    
    return dataSource;
}


#pragma mark - Task Manager Data Source

NSString *const TASK_ARCHIVE_NAME = @"TaskArchiveName";
NSString *const TASK_ARCHIVE_PRIORITY = @"TaskArchivePriority";

- (TaskListObject *)readTasks {
    
    NSMutableDictionary *newTasks = [NSMutableDictionary dictionaryWithContentsOfURL:self.propertyListURL];
    if (newTasks != nil) {
        
        // Enumerate each task and convert it from an "archived" NSDictionary representation to a Task object
        for (NSString *taskListTitle in newTasks.allKeys) {
            TaskList *unarchivedTaskList = [[TaskList alloc] init];
            
            [newTasks[taskListTitle] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull archivedTask, NSUInteger index, BOOL * _Nonnull stop) {
                
                NSString *taskName = [archivedTask objectForKey:TASK_ARCHIVE_NAME];
                NSNumber *taskPriorityNumber = [archivedTask objectForKey:TASK_ARCHIVE_PRIORITY];
                TaskPriority taskPriority = taskPriorityNumber.integerValue;
                
                unarchivedTaskList[index] = [[Task alloc] initWithName:taskName priority:taskPriority];
            }];
            
            newTasks[taskListTitle] = unarchivedTaskList;
        }

        return newTasks;
    } else {
        
        NSLog(@"Could not read property list data from URL %@", self.propertyListURL);
        return nil;
    }
}

- (BOOL)writeTasks: (TaskListObject *)tasks {
    
    NSMutableDictionary *oldTasks = tasks;
    
    // Enumerate each task and convert it from a Task object to an "archived" NSDictionary representation
    for (NSString *taskListTitle in oldTasks.allKeys) {
        NSMutableArray<NSDictionary *> *archivedTaskList = [[NSMutableArray alloc] init];
        
        [oldTasks[taskListTitle] enumerateObjectsUsingBlock:^(Task * _Nonnull task, NSUInteger index, BOOL * _Nonnull stop) {
            
            NSMutableDictionary *archivedTask = [[NSMutableDictionary alloc] init];
            [archivedTask setObject:task.name forKey:TASK_ARCHIVE_NAME];
            [archivedTask setObject:@(task.priority) forKey:TASK_ARCHIVE_PRIORITY];
            
            archivedTaskList[index] = [archivedTask copy];
        }];
        
        oldTasks[taskListTitle] = archivedTaskList;
    }
    
    if ([oldTasks writeToURL:self.propertyListURL atomically:YES]) {
        return YES;
    } else {
        NSLog(@"Could not save property list data from URL %@", self.propertyListURL);
        return NO;
    }
}

@end
