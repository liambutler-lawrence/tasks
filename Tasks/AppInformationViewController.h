//
//  AppInformationViewController.h
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/27/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AppInformationType) {
    AppInformationTypeFAQ,
    AppInformationTypeAbout
};

@interface AppInformationViewController : UIViewController

// Must be set before the view loads
// Used to retrieve the text to display
@property (nonatomic) AppInformationType informationType;

@end
