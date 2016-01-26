//
//  TaskViewController.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "TaskViewController.h"

@interface TaskViewController ()

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.taskListTitle == nil) {
        [self setupCreateMode];
    } else {
        [self setupEditMode];
    }
}

- (void)setupEditMode {
    
}

- (void)setupCreateMode {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:NSSelectorFromString(@"doneButtonTapped:")];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:NSSelectorFromString(@"cancelButtonTapped:")];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)doneButtonTapped: (UIBarButtonItem *) sender {
    // save task to task manager and dismiss
}

- (void)cancelButtonTapped: (UIBarButtonItem *) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
