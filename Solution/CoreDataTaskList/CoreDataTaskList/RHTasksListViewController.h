//
//  RHTasksInListViewController.h
//  CoreDataTaskList
//
//  Created by David Fisher on 11/2/13.
//  Copyright (c) 2013 Rose-Hulman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RHTaskList;

@interface RHTasksListViewController : UITableViewController <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) RHTaskList* taskList;
@property (nonatomic, strong) NSArray* tasks;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *optionsBarButtonItem;

- (IBAction)pressedOptions:(id)sender;

@end
