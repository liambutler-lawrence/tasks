//
//  SwitchTaskListsTableViewController.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/26/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "SwitchTaskListsTableViewController.h"

@interface SwitchTaskListsTableViewController ()

@end

@implementation SwitchTaskListsTableViewController


#pragma mark - Storyboard Actions

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonTapped:(UIBarButtonItem *)sender {
    [self createNewTaskList];
}


#pragma mark - Task List Manipulation Methods

- (void)deleteTaskListAtIndexPath: (NSIndexPath *)indexPath {
    NSArray <NSString *> *taskListTitles = [[TaskManager sharedManager] taskListTitles];
    NSString *selectedTaskListTitle = taskListTitles[indexPath.row];
    
    UIAlertController *deleteConfirmationAlertController = [UIAlertController alertControllerWithTitle:@"Delete List"
                                                                                               message:@"Deleting this list will delete all of its tasks."
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [[TaskManager sharedManager] removeTaskListWithTitle:selectedTaskListTitle];
                                                             [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                         }];
    [deleteConfirmationAlertController addAction:deleteAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [deleteConfirmationAlertController addAction:cancelAction];
    
    [self presentViewController:deleteConfirmationAlertController animated:YES completion:nil];
}

- (void)createNewTaskList {
    UIAlertController *newListAlertController = [UIAlertController alertControllerWithTitle:@"New List"
                                                                                    message:@"Please enter the name of the list."
                                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    [newListAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textField.returnKeyType = UIReturnKeyDone;
    }];
    
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          NSString *newListTitle = newListAlertController.textFields.firstObject.text;
                                                          if ([[TaskManager sharedManager] addTaskListWithTitle:newListTitle]) {
                                                              [self newTaskListCreatedWithTitle:newListTitle];
                                                          } else {
                                                              [self newTaskListCreationFailed];
                                                          }
                                                      }];
    [newListAlertController addAction:addAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [newListAlertController.textFields.firstObject resignFirstResponder];
                                                         }];
    [newListAlertController addAction:cancelAction];
    
    [self presentViewController:newListAlertController animated:YES completion:nil];
}

- (void)newTaskListCreatedWithTitle: (NSString *)newTaskListTitle {
    
    NSArray <NSString *> *taskListTitles = [[TaskManager sharedManager] taskListTitles];
    NSInteger selectedTaskListIndex = [taskListTitles indexOfObject:newTaskListTitle];
    
    NSIndexPath *newTaskListIndexPath = [NSIndexPath indexPathForRow:selectedTaskListIndex inSection:0]; // All task lists are presented in a single section
    [self.tableView insertRowsAtIndexPaths:@[newTaskListIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)newTaskListCreationFailed {
    UIAlertController *errorAlertController = [UIAlertController alertControllerWithTitle:@"List Cannot Be Added"
                                                                                  message:@"The name you entered is already in use or is reserved. Please choose a different name."
                                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [errorAlertController addAction:okAction];
    [self presentViewController:errorAlertController animated:YES completion:nil];
}


#pragma mark - Table View


#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray <NSString *> *taskListTitles = [[TaskManager sharedManager] taskListTitles];
    NSString *selectedTaskListTitle = taskListTitles[indexPath.row];
    
    if (![selectedTaskListTitle isEqualToString:self.delegate.taskListTitle]) {
        self.delegate.taskListTitle = selectedTaskListTitle;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; // All task lists are presented in a single section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger taskListCount = [[TaskManager sharedManager] taskListTitles].count;
    return taskListCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reusableCellIdentifier = @"TaskListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier forIndexPath:indexPath];
    
    NSArray <NSString *> *taskListTitles = [[TaskManager sharedManager] taskListTitles];
    cell.textLabel.text = taskListTitles[indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:self.delegate.taskListTitle]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray <NSString *> *taskListTitles = [[TaskManager sharedManager] taskListTitles];
    NSString *selectedTaskListTitle = taskListTitles[indexPath.row];
    
    if ([selectedTaskListTitle isEqualToString:ALL_TASKS] || [selectedTaskListTitle isEqualToString:self.delegate.taskListTitle]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteTaskListAtIndexPath:indexPath];
    }
}

@end
