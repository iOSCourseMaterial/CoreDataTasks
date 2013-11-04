//
//  RHAllListsViewController.m
//  CoreDataTaskList
//
//  Created by David Fisher on 11/2/13.
//  Copyright (c) 2013 Rose-Hulman. All rights reserved.
//

#import "RHAllListsViewController.h"
#import "RHAppDelegate.h"
#import "RHTasksListViewController.h"

#define kTaskListCellIdentifier @"TaskListCell"
#define kNoTaskListsCellIdentifier @"NoTaskListsCell"
#define kPushTaskListSegue @"PushTaskListSegue"

@interface RHAllListsViewController ()
@property (nonatomic, weak) NSManagedObjectContext* moc;
@property (nonatomic) BOOL showingRenameButtons;
@property (nonatomic) NSIndexPath* accessorySelectedIndexPath;
@end

@implementation RHAllListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showingRenameButtons = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [self _reloadTable];
}

- (NSManagedObjectContext*) moc {
    if (_moc == nil) {

        // TODO: Get the managed object context from the app delegate.

    }
    return _moc;
}


- (IBAction)pressedOptions:(id)sender {
    NSString* toggleRenameButtonsTitle = @"Show rename buttons";
    if (self.showingRenameButtons) {
        toggleRenameButtonsTitle = @"Hide rename buttons";
    }
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Add a list", @"Delete a list", toggleRenameButtonsTitle, nil];
    [actionSheet showInView:self.view];    
}


- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        NSLog(@"Change the right button to the edit button for Done.");
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    } else {
        NSLog(@"Put back the options button");
        self.navigationItem.rightBarButtonItem = self.optionsBarButtonItem;
    }
}


- (void) _reloadTable {

    // Load the lists with a Core Data fetch.

    [self.tableView reloadData];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.lists.count == 0) {
        return 1;
    }
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    if (self.lists.count == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kNoTaskListsCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kTaskListCellIdentifier forIndexPath:indexPath];

        // TODO: Use the current list item to set the textLabel.text

        if (self.showingRenameButtons) {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            //            cell.accessoryType = UITableViewCellAccessoryDetailButton;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lists.count == 0) {
        return NO;
    }
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        // TODO: Remove the list and save the moc.

        [self _reloadTable];
    }
}


#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lists.count == 0) {
        return;
    }

    // TODO: Pass this row's list as the sender.

    [self performSegueWithIdentifier:kPushTaskListSegue sender:nil];
}


- (void) tableView:(UITableView*) tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    self.accessorySelectedIndexPath = indexPath;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Edit list title"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Update title", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField* tf = [alert textFieldAtIndex:0];
    tf.placeholder = @"New title for task list";

    // TODO: Get the current row list and set the tf.text

    [tf setClearButtonMode:UITextFieldViewModeAlways];
    [alert show];
}


#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        NSLog(@"Cancel pressed.");
        return;
    }
    switch (buttonIndex) {
        case 0:
        {
            // Add a list
            self.accessorySelectedIndexPath = nil;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Create a new list"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Create list", nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField* tf = [alert textFieldAtIndex:0];
            tf.placeholder = @"Name for task list";
            [alert show];
        }
            break;
        case 1:
            // Delete a list
            [self setEditing:YES animated:YES];
            break;
        case 2:
            // Toggle rename button state
            NSLog(@"Toggle rename buttons");
            self.showingRenameButtons ^= YES;
            [self.tableView reloadData];
            break;
    }

}

#pragma mark - UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (self.accessorySelectedIndexPath == nil) {
            NSLog(@"Adding a new list");
            NSString* listTitle = [[alertView textFieldAtIndex:0] text];

            // TODO: Create a new list, save the moc, and reload the table.


            [self _reloadTable];
        } else {
            NSLog(@"Updating an existing list title");
            NSString* newListTitle = [[alertView textFieldAtIndex:0] text];

            // TODO: Get the list using hte accessorySelecedIndexPath.row.  Update the title, save the moc, and reload the row.

        }
        
    }
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kPushTaskListSegue]) {
        RHTasksListViewController* destination = segue.destinationViewController;

        // TODO: Set the taskList on the destination to the sender.
    }
}



@end
