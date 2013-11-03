//
//  RHTaskDetailViewController.m
//  CoreDataTaskList
//
//  Created by David Fisher on 11/2/13.
//  Copyright (c) 2013 Rose-Hulman. All rights reserved.
//

#import "RHTaskDetailViewController.h"
#import "RHAppDelegate.h"
#import "RHTask.h"

@interface RHTaskDetailViewController ()
@property (nonatomic, weak) NSManagedObjectContext* moc;

@end

@implementation RHTaskDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    self.taskTextView.text = self.task.taskText;
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
    tf.text = self.task.taskText;
    [alert show];

}

#pragma mark - UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSLog(@"Updating a new task");
        NSString* taskText = [[alertView textFieldAtIndex:0] text];
        self.task.created = [NSDate date];
        self.task.taskText = taskText;
        NSError* error;
        [self.moc save:&error];
        if (error != nil) {
            NSLog(@"Error saving moc %@", error.localizedDescription);
            return;
        }
        self.taskTextView.text = self.task.taskText;
    }
}


@end
