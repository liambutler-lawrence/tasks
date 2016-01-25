//
//  UIStoryboard+ClassIdentifier.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/25/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

@import UIKit;

@interface UIStoryboard (ClassIdentifier)

// Returns the view controller with the reuse identifier equivalent to calling NSStringFromClass() on the classIdentifier parameter
// Throws an exception if no such view controller exists
- (__kindof UIViewController *)instantiateViewControllerWithClassIdentifier:(Class)classIdentifier;

@end
