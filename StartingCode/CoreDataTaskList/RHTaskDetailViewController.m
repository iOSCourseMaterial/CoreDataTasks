//
//  RHTaskDetailViewController.m
//  CoreDataTaskList
//
//  Created by David Fisher on 11/2/13.
//  Copyright (c) 2013 Rose-Hulman. All rights reserved.
//

#import "RHTaskDetailViewController.h"
#import "RHAppDelegate.h"
// TODO: Add necessary imports

@interface RHTaskDetailViewController ()
@property (nonatomic, weak) NSManagedObjectContext* moc;

@end

@implementation RHTaskDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {

    // TODO: Load the taskTextView with the task text.

}

- (NSManagedObjectContext*) moc {
    if (_moc == nil) {
        RHAppDelegate* ad = [[UIApplication sharedApplication] delegate];
        _moc = ad.managedObjectContext;
    }
    return _moc;
}

- (IBAction)pressedEditTask:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Edit task"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Update task", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField* tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"Task...";

    // TODO: Populate the tf text with the task text.

    [alert show];

}

#pragma mark - UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSLog(@"Updating a new task");
        NSString* taskText = [[alertView textFieldAtIndex:0] text];

        // TODO: Update the task with the next text and save the moc.
        // TODO: Update the view.

    }
}


@end
