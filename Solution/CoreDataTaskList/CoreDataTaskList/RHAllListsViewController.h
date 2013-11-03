//
//  RHAllListsViewController.h
//  CoreDataTaskList
//
//  Created by David Fisher on 11/2/13.
//  Copyright (c) 2013 Rose-Hulman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHAllListsViewController : UITableViewController <UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSArray* lists;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *optionsBarButtonItem;

- (IBAction)pressedOptions:(id)sender;

@end
