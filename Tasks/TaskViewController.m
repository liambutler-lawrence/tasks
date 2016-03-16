//
//  TaskViewController.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "TaskViewController.h"

NSInteger const NEW_TASK = -1;


@interface TaskViewController ()

#pragma mark Storyboard Outlets
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *listTitleLabel;

@end


@implementation TaskViewController

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listTitleLabel.text = self.taskListTitle;
    
    if (self.taskIndex == NEW_TASK) {
        [self setupCreateMode];
    } else {
        [self setupEditMode];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Animate keyboard removal alongside view controller pop animation
    [self.nameTextField resignFirstResponder];
    
    // Save changes to task made in 'edit' mode.
    if (self.taskIndex != NEW_TASK) {
        Task *task = [[TaskManager sharedManager] taskListWithTitle:self.taskListTitle][self.taskIndex];
        NSString *newName = self.nameTextField.text;
        if (newName != nil && newName.length > 0) {
            task.name = self.nameTextField.text;
        }
        task.priority = self.prioritySegmentedControl.selectedSegmentIndex;
    }
}

#pragma mark - Setup Methods

- (void)setupEditMode {
    Task *task = [[TaskManager sharedManager] taskListWithTitle:self.taskListTitle][self.taskIndex];
    self.nameTextField.text = task.name;
    self.prioritySegmentedControl.selectedSegmentIndex = task.priority;
}

- (void)setupCreateMode {
    
    self.navigationItem.title = @"New Task";
    self.prioritySegmentedControl.selectedSegmentIndex = TASK_PRIORITY_DEFAULT;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(addButtonTapped:)];
    addButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

#pragma mark - Target/Action Methods

- (void)addButtonTapped: (UIBarButtonItem *)sender {
    
    TaskPriority newTaskPriority = self.prioritySegmentedControl.selectedSegmentIndex;
    Task *newTask = [[Task alloc] initWithName:self.nameTextField.text priority:newTaskPriority];
    
    [[TaskManager sharedManager] addTask:newTask toTaskListWithTitle:self.taskListTitle];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonTapped: (UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Text Field Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.navigationItem.rightBarButtonItem != nil) {
        NSInteger oldTextLength = textField.text.length;
        NSInteger newTextLength = oldTextLength - range.length + string.length;
        
        if (newTextLength == 0) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        } else if (oldTextLength == 0) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)taskPrioritySegmentedControlTapped:(id)sender {
    /*if(self.prioritySegmentedControl.selectedSegmentIndex == 0) {
        self.prioritySegmentedControl.accessibilityValue = 0;
    } else if (self.prioritySegmentedControl.selectedSegmentIndex == 1) {
        self.prioritySegmentedControl.accessibilityValue = 1;
    } else {
        self.prioritySegmentedControl.accessibilityValue = 2;
    }*/
    self.prioritySegmentedControl.accessibilityValue = [NSString stringWithFormat:@"%ld", (long)self.prioritySegmentedControl.selectedSegmentIndex];
    NSLog(@"%@", self.prioritySegmentedControl.accessibilityValue);
}


@end
