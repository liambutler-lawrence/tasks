//
//  HomePageViewController.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (IBAction)infoButtonTapped:(UIBarButtonItem *)sender {
}
- (IBAction)switchListsButtonTapped:(UIBarButtonItem *)sender {
}

- (IBAction)addTaskButtonTapped:(UIBarButtonItem *)sender {
}
- (IBAction)removeTaskButtonTapped:(UIBarButtonItem *)sender {
}

- (IBAction)saveListButtonTapped:(UIBarButtonItem *)sender {
}
#pragma mark - Page View Controller

#pragma mark Delegate



#pragma mark Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    TaskListTableViewController *contentViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithClassIdentifier:[TaskListTableViewController class]];
    return contentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    TaskListTableViewController *contentViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithClassIdentifier:[TaskListTableViewController class]];
    return contentViewController;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // The container view relationship between this VC and the PageVC is defined as an 'embed' segue
    // Therefore, prepareForSegue is called before loading the container view, allowing the PageVC to be setup
    if ([segue.identifier isEqualToString:@"PageViewControllerEmbed"]) {
        UIPageViewController *pageViewController = segue.destinationViewController;
        
        pageViewController.delegate = self;
        pageViewController.dataSource = self;
        
        // The PageVC must be given at least one initial VC to display. VCs displayed in response to right/left swipes are set above in the Page View Controller: Data Source section
        TaskListTableViewController *contentViewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithClassIdentifier:[TaskListTableViewController class]];
        [pageViewController setViewControllers:@[contentViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

@end