//
//  RequestsTableViewController.m
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-08-01.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import "RequestsTableViewController.h"
#import "RequestsTableViewCell.h"

@interface RequestsTableViewController ()

@property UIActivityIndicatorView *ac;
@property UIView *acView;

@end

@implementation RequestsTableViewController

@synthesize requestsTable;
@synthesize ac;
@synthesize acView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    
    self.ac = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.acView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 113, self.view.frame.origin.y + 240, 100, 100)];
    
    self.acView.alpha = 0.7;
    self.acView.hidden = YES;
    self.acView.backgroundColor = [UIColor blackColor];
    self.acView.layer.cornerRadius = 20;
    
    
    self.ac.alpha = 1.0;
    self.ac.hidesWhenStopped = YES;
    self.ac.frame = CGRectMake(50, 50, 0, 0);
    self.ac.transform = transform;
    
    [self.acView addSubview:self.ac];
    [self.view addSubview:self.acView];
    
    self.requests = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated {
    [self retrieveRequests];
    self.acView.hidden = NO;
    [self.ac startAnimating];
}

- (void)retrieveRequests {
    
    PFUser *userId = [PFUser currentUser];
    [userId valueForKey:@"objectId"];
    
    PFQuery *toUserQuery = [PFQuery queryWithClassName:@"FriendRequest"];
    [toUserQuery whereKey:@"toUser" equalTo:userId];
    [toUserQuery whereKey:@"status" equalTo:@"pending"];
    [toUserQuery orderByDescending:@"createdAt"];
    [toUserQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            [self.requests removeAllObjects];
            [self.requests addObjectsFromArray:objects];
            [self.requestsTable reloadData];
            NSLog(@"successful query, %@", self.requests);
            [self.ac stopAnimating];
            self.acView.hidden = YES;
        }
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.requests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RequestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    PFObject *userRequests = [self.requests objectAtIndex:indexPath.row];
    
    NSString *full = [userRequests objectForKey:@"fullName"];
    
    if ([full isEqualToString:NULL] || [full isEqualToString:@""]) {
        full = @"Full Name Unavailable";
    }
    
    cell.usernameLabel.text = [userRequests objectForKey:@"fromUsername"];
    cell.nameLabel.text = full;
    cell.acceptBtn.tag = indexPath.row;
    cell.declineBtn.tag = indexPath.row;
    
    [cell.acceptBtn addTarget:self action:@selector(acceptSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cell.declineBtn addTarget:self action:@selector(declineSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void)acceptSelected:(UIButton *)sender {
    
    PFObject *tempObject = [self.requests objectAtIndex:sender.tag];
    [tempObject setValue:@"accepted" forKey:@"status"];
    [tempObject saveInBackground];
    if ([[tempObject objectForKey:@"status"] isEqualToString:@"accepted"]) {
        [UIView animateWithDuration:0.5 animations:^{
            [sender setImage:[UIImage imageNamed:@"accepted"] forState:UIControlStateNormal];
        }];
    }
    
    ////create relation here
    PFUser *currentUser = [PFUser currentUser];
    [currentUser incrementKey:@"ContactsNumber"];
    PFRelation *toUserRelation = [currentUser relationForKey:@"Contacts"];
    PFObject *fromUser = [tempObject objectForKey:@"fromUser"];
    PFQuery *fromUserQuery = [PFUser query];
    [fromUserQuery whereKey:@"objectId" equalTo:fromUser.objectId];
    [fromUserQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            [toUserRelation addObject:object];
            [currentUser saveInBackground];
            [PFCloud callFunction:@"fromUserRelation" withParameters:@{@"toUserId": currentUser.objectId, @"fromUserId": fromUser.objectId}];
            
            [self.requests removeObjectAtIndex:sender.tag];
            NSArray *array = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil];
            [self.requestsTable deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationRight];
            [self.requestsTable reloadData];
        }
    }];

}

- (void)declineSelected:(UIButton *)sender {
    
    PFObject *tempObject = [self.requests objectAtIndex:sender.tag];
    [tempObject setValue:@"declined" forKey:@"status"];
    [tempObject saveInBackground];
    if ([[tempObject objectForKey:@"status"] isEqualToString:@"declined"]) {
        [UIView animateWithDuration:2.0 animations:^{
            [sender setImage:[UIImage imageNamed:@"declined"] forState:UIControlStateNormal];
        }];
    }
    
    [self.requests removeObject:tempObject];
    NSArray *array = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:0], nil];
    [self.requestsTable deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
    [self.requestsTable reloadData];
}

@end
