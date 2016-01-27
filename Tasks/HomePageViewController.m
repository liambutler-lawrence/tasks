//
//  HomePageViewController.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "HomePageViewController.h"


@interface HomePageViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) UIPageViewController *pageViewController;

@end


@implementation HomePageViewController

#pragma mark - Storyboard Actions

- (IBAction)infoButtonTapped:(UIBarButtonItem *)sender {
    
    UIAlertController *infoActionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *openFAQAction = [UIAlertAction actionWithTitle:@"FAQ"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    [infoActionSheet addAction:openFAQAction];
    
    UIAlertAction *openAboutAction = [UIAlertAction actionWithTitle:@"About"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    [infoActionSheet addAction:openAboutAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [infoActionSheet addAction:cancelAction];
    
    // Action sheets display using popover controller on iPad
    // Popover controller must be anchored to a UIBarButtonItem (or custom view)
    if (infoActionSheet.popoverPresentationController != nil) {
        infoActionSheet.popoverPresentationController.barButtonItem = sender;
    }
    
    [self presentViewController:infoActionSheet animated:YES completion:nil];
}

- (IBAction)switchListsButtonTapped:(UIBarButtonItem *)sender {
    
    SwitchTaskListsTableViewController *switchListsTableViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithClassIdentifier:[SwitchTaskListsTableViewController class]];
    switchListsTableViewController.delegate = self;
    
    UINavigationController *createTaskNavigationController = [[UINavigationController alloc] initWithRootViewController:switchListsTableViewController];
    
    [self presentViewController:createTaskNavigationController animated:YES completion:nil];
}

- (IBAction)addTaskButtonTapped:(UIBarButtonItem *)sender {
    
    TaskViewController *createTaskViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithClassIdentifier:[TaskViewController class]];
    UINavigationController *createTaskNavigationController = [[UINavigationController alloc] initWithRootViewController:createTaskViewController];
    
    NSString *taskListTitle = self.taskListTitle;
    if ([taskListTitle isEqualToString:ALL_TASKS]) {
        createTaskViewController.taskListTitle = NO_LIST;
    } else {
        createTaskViewController.taskListTitle = taskListTitle;
    }
    createTaskViewController.taskIndex = NEW_TASK;
    
    [self presentViewController:createTaskNavigationController animated:YES completion:nil];
}

- (IBAction)removeTasksButtonTapped:(UIBarButtonItem *)sender {
    
    TaskListTableViewController *taskListTableViewController = self.pageViewController.viewControllers.firstObject;
    if (taskListTableViewController.tableView.isEditing) {
        [taskListTableViewController.tableView setEditing:NO animated:YES];
    } else {
        [taskListTableViewController.tableView setEditing:YES animated:YES];
    }
}

- (IBAction)saveListButtonTapped:(UIBarButtonItem *)sender {
    
    [[TaskManager sharedManager] saveTasksToDataSource:[TaskPropertyListDataSource defaultDataSource]];
}

#pragma mark - View Controller

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // Notifies toolbar to redraw if needed (specifically, when self.view transitions to/from compact height)
    [self.toolbar invalidateIntrinsicContentSize];
}

#pragma mark - Page View Controller

#pragma mark Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.navigationItem.title = self.taskListTitle;
    }
}

#pragma mark Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return [self newViewControllerFromCurrentViewController:viewController
                                                  direction:UIPageViewControllerNavigationDirectionReverse];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    return [self newViewControllerFromCurrentViewController:viewController
                                                  direction:UIPageViewControllerNavigationDirectionForward];

}

#pragma mark - Helper Methods

- (UIViewController *)newViewControllerFromCurrentViewController: (UIViewController *)viewController direction: (UIPageViewControllerNavigationDirection)direction {
    
    TaskListTableViewController *oldContentViewController = (TaskListTableViewController *)viewController;
    TaskListTableViewController *newContentViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithClassIdentifier:[TaskListTableViewController class]];
        
    NSArray<NSString *> *taskListTitles = [[TaskManager sharedManager] taskListTitles];
    NSInteger currentTitleIndex = [taskListTitles indexOfObject:oldContentViewController.taskListTitle];
    
    NSInteger newTitleIndex;
    switch (direction) {
        case UIPageViewControllerNavigationDirectionForward:
            
            newTitleIndex = currentTitleIndex + 1;
            if (newTitleIndex >= taskListTitles.count) {
                return nil;
            }
            break;
        case UIPageViewControllerNavigationDirectionReverse:
            
            newTitleIndex = currentTitleIndex - 1;
            if (newTitleIndex < 0) {
                return nil;
            }
            break;
    }
    newContentViewController.taskListTitle = taskListTitles[newTitleIndex];
    
    return newContentViewController;
}

#pragma mark - Switch Task Lists Table View Controller Delegate

- (NSString *)taskListTitle {
    
    TaskListTableViewController *viewController = self.pageViewController.viewControllers.firstObject;
    return viewController.taskListTitle;
}

- (void)setTaskListTitle: (NSString *)title {
    
    TaskListTableViewController *newContentViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithClassIdentifier:[TaskListTableViewController class]];
    newContentViewController.taskListTitle = title;

    [self.pageViewController setViewControllers:@[newContentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.navigationItem.title = title;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // The container view relationship between this view controller and the PageViewController is defined as an 'embed' segue
    // Therefore, prepareForSegue is called before loading the container view, allowing the PageViewController to be setup
    if ([segue.identifier isEqualToString:@"PageViewControllerEmbed"]) {
        self.pageViewController = segue.destinationViewController;
        
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
        
        // The PageViewController must be given at least one initial view controller to display. View controllers displayed in response to right/left swipes are set above in the Page View Controller: Data Source section
        TaskListTableViewController *contentViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithClassIdentifier:[TaskListTableViewController class]];
        
        
        contentViewController.taskListTitle = ALL_TASKS;
        self.navigationItem.title = contentViewController.taskListTitle;
    
        [self.pageViewController setViewControllers:@[contentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

@end