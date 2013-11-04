//
//  RHTaskDetailViewController.h
//  CoreDataTaskList
//
//  Created by David Fisher on 11/2/13.
//  Copyright (c) 2013 Rose-Hulman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHTaskDetailViewController : UIViewController <UIAlertViewDelegate>

// TODO: Create a property for a task.

@property (strong, nonatomic) IBOutlet UITextView *taskTextView;

- (IBAction)pressedEditTask:(id)sender;

@end
