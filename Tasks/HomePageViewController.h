//
//  HomePageViewController.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

@import UIKit;

#import "TaskListTableViewController.h"
#import "SwitchTaskListsTableViewController.h"
#import "AppInformationViewController.h"
#import "TaskPropertyListDataSource.h"

@interface HomePageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, SwitchTaskListsTableViewControllerDelegate>

@end
