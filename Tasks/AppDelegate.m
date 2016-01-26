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
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
}

@end
