//
//  UIStoryboard+ClassIdentifier.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "UIStoryboard+ClassIdentifier.h"

@implementation UIStoryboard (ClassIdentifier)

- (__kindof UIViewController *)instantiateViewControllerWithClassIdentifier:(Class)classIdentifier {
    return [self instantiateViewControllerWithIdentifier:NSStringFromClass(classIdentifier)];
}

@end
