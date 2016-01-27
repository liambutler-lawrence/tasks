//
//  AppInformationViewController.m
//  Tasks
//
//  Created by Liam Butler-Lawrence on 1/27/16.
//  Copyright © 2016 Liam Butler-Lawrence. All rights reserved.
//

#import "AppInformationViewController.h"


@interface AppInformationViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end


@implementation AppInformationViewController

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // iOS bug: UITextView scrolls the content around halfway down at some point between viewDidLoad and viewDidAppear
    // Workaround: disable scrolling on viewDidLoad and enable it again on viewDidAppear
    self.textView.scrollEnabled = NO;
    
    NSInteger edgeInset = 20;
    self.textView.textContainerInset = UIEdgeInsetsMake(edgeInset, edgeInset, edgeInset, edgeInset);
    
    NSString *textFileResourceName;
    switch (self.informationType) {
        case AppInformationTypeAbout:
            self.navigationItem.title = @"About";
            textFileResourceName = @"InformationAbout";
            break;
        case AppInformationTypeFAQ:
            self.navigationItem.title = @"FAQ";
            textFileResourceName = @"InformationFAQ";
            break;
    }
    NSURL *textFileURL = [[NSBundle mainBundle] URLForResource:textFileResourceName withExtension:@"txt"];
    
    NSError *dataReadError;
    NSString *informationText = [NSString stringWithContentsOfURL:textFileURL encoding:NSUTF8StringEncoding error:&dataReadError];
    if (informationText == nil) {
        NSLog(@"Failed to read information from text file at URL: %@. Error: %@", textFileURL, dataReadError);
    } else {
        self.textView.text = informationText;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // iOS bug: UITextView scrolls the content around halfway down at some point between viewDidLoad and viewDidAppear
    // Workaround: disable scrolling on viewDidLoad and enable it again on viewDidAppear
    self.textView.scrollEnabled = YES;
}

@end
