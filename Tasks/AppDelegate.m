//
//  AppDelegate.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self customizeAppAppearance];
    
    // NSUserDefaults boolForKey: returns NO if key is not present
    NSString *afterFirstLaunchKey = @"AfterFirstLaunch";
    BOOL afterFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:afterFirstLaunchKey];
    
    if (afterFirstLaunch) {
        
        [[TaskManager sharedManager] addTasksFromDataSource:[TaskPropertyListDataSource defaultDataSource]];
    } else {
        
        NSURL *plainTextURL = [[NSBundle mainBundle] URLForResource:@"ExampleData" withExtension:@"txt"];
        TaskPlainTextDataSource *plainTextDataSource = [[TaskPlainTextDataSource alloc] initWithPlainTextURL:plainTextURL];
        [[TaskManager sharedManager] addTasksFromDataSource:plainTextDataSource];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:afterFirstLaunchKey];
    }
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[TaskManager sharedManager] saveTasksToDataSource:[TaskPropertyListDataSource defaultDataSource]];
}

- (void)customizeAppAppearance {
    
    UIColor *customPurpleColor = [UIColor colorWithHue:0.728 saturation:0.42 brightness:0.49 alpha:1];
    
    
    // Customize UINavigationBar appearance
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    // Even though tint colors are set manually (below), 'Black' style is needed to make the status bar text appear in white.
    [navigationBarAppearance setBarStyle:UIBarStyleBlack];
    
    [navigationBarAppearance setBarTintColor:customPurpleColor];
    [navigationBarAppearance setTranslucent:NO];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    
    // if titleTextAttributes dictionary does not exist, initialize an empty dictionary
    if ([navigationBarAppearance titleTextAttributes] == nil) {
        [navigationBarAppearance setTitleTextAttributes:[[NSDictionary<NSString *, id> alloc] init]];
    }
    
    // make mutable copy of titleTextAttributes to set foreground color; writeback non-mutable copy of updated dictionary
    NSMutableDictionary<NSString *, id> *attributes = [[navigationBarAppearance titleTextAttributes] mutableCopy];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navigationBarAppearance setTitleTextAttributes:[attributes copy]];
    
    
    // Customize UIToolbar appearance
    UIToolbar *toolbarAppearance = [UIToolbar appearance];
    
    [toolbarAppearance setBarTintColor:customPurpleColor];
    [toolbarAppearance setTranslucent:NO];
    [toolbarAppearance setTintColor:[UIColor whiteColor]];
    
    
    // Customize UISegmentedControl appearance
    UISegmentedControl *segmentedControlAppearance = [UISegmentedControl appearance];
    
    [segmentedControlAppearance setTintColor:customPurpleColor];
}

@end
