//
//  UIStoryboard+MainStoryboard.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "UIStoryboard+MainStoryboard.h"

@implementation UIStoryboard (MainStoryboard)

+ (instancetype)mainStoryboard {
    NSString *mainStoryboardName = @"Main";
    return [self storyboardWithName:mainStoryboardName bundle:nil];
}

@end
