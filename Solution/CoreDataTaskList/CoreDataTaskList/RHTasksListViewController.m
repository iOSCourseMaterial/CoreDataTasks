//
//  RHTasksInListViewController.m
//  CoreDataTaskList
//
//  Created by David Fisher on 11/2/13.
//  Copyright (c) 2013 Rose-Hulman. All rights reserved.
//

#import "RHTasksListViewController.h"
#import "RHTaskList.h"
#import "RHTask.h"
#import "RHAppDelegate.h"
#import "RHTaskDetailViewController.h"


#define kTaskCellIdentifier @"TaskCell"
#define kNoTasksCellIdentifier @"NoTasksCell"
#define kPushTaskDetailSegue @"PushTaskDetailSegue"



@interface RHTasksListViewController ()
@property (nonatomic, weak) NSManagedObjectContext* moc;

@end

@implementation RHTasksListViewController

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    self.title = self.taskList.title;
    [self _reloadTable];
}

- (NSManagedObjectContext*) moc {
    if (_moc == nil) {
        RHAppDelegate* ad = [[UIApplication sharedApplication] delegate];
        _moc = ad.managedObjectContext;
    }
    return _moc;
}


- (void) _reloadTable {
    self.tasks = [self.taskList.tasks.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[(RHTask*) obj1 created] compare:[(RHTask*) obj2 created]];
    }];
    [self.tableView reloadData];
}

- (IBAction)pressedOptions:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Add a task", @"Delete a task", nil];
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

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tasks.count == 0) {
        return 1;
    }
    return self.tasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (self.tasks.count == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kNoTasksCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kTaskCellIdentifier forIndexPath:indexPath];
        RHTask* task = self.tasks[indexPath.row];
        cell.textLabel.text = task.taskText;
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (self.tasks.count == 0) {
        return NO;
    }
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source

        RHTask* currentTask = self.tasks[indexPath.row];
        NSError* error = nil;
        [self.moc deleteObject:currentTask];
        [self.moc save:&error];
        if (error != nil) {
            NSLog(@"Error saving moc.");
            return;
        }
        [self _reloadTable];
    }
}


#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tasks.count == 0) {
        return;
    }
    RHTaskList* currentList = self.tasks[indexPath.row];
    [self performSegueWithIdentifier:kPushTaskDetailSegue sender:currentList];
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
            // Add a task
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Create a new task"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Create task", nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField* tf = [alert textFieldAtIndex:0];
            tf.placeholder = @"Task...";
            [alert show];
        }
            break;
        case 1:
            // Delete a list
            [self setEditing:YES animated:YES];
            break;
    }

}

#pragma mark - UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSLog(@"Adding a new task");
        NSString* taskText = [[alertView textFieldAtIndex:0] text];

        RHTask* newTask = [NSEntityDescription insertNewObjectForEntityForName:@"RHTask"
                                                            inManagedObjectContext:self.moc];
        newTask.created = [NSDate date];
        newTask.taskText = taskText;
        newTask.list = self.taskList;
        NSError* error;
        [self.moc save:&error];
        if (error != nil) {
            NSLog(@"Error saving moc %@", error.localizedDescription);
            return;
        }
        [self _reloadTable];
    }
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kPushTaskDetailSegue]) {
        RHTaskDetailViewController* destination = segue.destinationViewController;
        destination.task = sender;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
