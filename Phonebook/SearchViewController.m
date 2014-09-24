//
//  SearchViewController.m
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-07-29.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import "SearchViewController.h"
#import <Parse/Parse.h>

@interface SearchViewController () 

@property (strong, nonatomic) PFObject *requestedUser;
@property (strong, nonatomic) UIImageView *mail;
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self checkUserIsNotCurrentUser];
    return NO;
}

- (void)checkUserIsNotCurrentUser {
    
    PFUser *currentUser = [PFUser currentUser];

    if ([self.usernameSearchField.text isEqualToString:currentUser.username]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"You cannot request yourself." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self checkUserExistsBeforeAdding];
        [_addUserBtn setTitle:@"Requesting..." forState:UIControlStateNormal]; // To set the title
        [_addUserBtn setEnabled:NO];
    }
}

- (void)checkUserExistsBeforeAdding {
    
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"username" equalTo:self.usernameSearchField.text];
    
    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User not found." message:@"Please type in a correct username." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [_addUserBtn setTitle:@"Request" forState:UIControlStateNormal]; // To set the title
            [_addUserBtn setEnabled:YES];
        }
        else {
            self.requestedUser = object;
            [self checkIfUserAddedBefore];
        }
    }];
    
}

- (void)checkIfUserAddedBefore {
    
    PFQuery *addedQuery = [PFQuery queryWithClassName:@"FriendRequest"];
    [addedQuery whereKey:@"toUser" equalTo:self.requestedUser];
    [addedQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    [addedQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention." message:@"You have added this person before." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [_addUserBtn setTitle:@"Request" forState:UIControlStateNormal]; // To set the title
            [_addUserBtn setEnabled:YES];
        }
        else {
            [self sendFriendRequest];
        }
    }];
    
}

- (void)sendFriendRequest {
    
    PFObject *request = [PFObject objectWithClassName:@"FriendRequest"];
    NSString *pending = @"pending";
    
    PFObject *currentUserInfo = [PFUser currentUser];
    NSString *full = [currentUserInfo objectForKey:@"FullName"];

    if (full == NULL && [full isEqualToString:@""]) {
        full = [NSString stringWithFormat:@"Unavailable"];
    }
    
    [request setObject:[PFUser currentUser] forKey:@"fromUser"];
    [request setObject:[PFUser currentUser].username forKey:@"fromUsername"];
    [request setObject:full forKey:@"fullName"];
    [request setValue:self.requestedUser forKey:@"toUser"];
    [request setObject:pending forKey:@"status"];
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Something went wrong when sending your request, please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [_addUserBtn setTitle:@"Request" forState:UIControlStateNormal]; // To set the title
            [_addUserBtn setEnabled:YES];
        }
        else {
            self.requestSentLabel.text = @"Request Sent.";
            self.requestSentLabel.hidden = NO;
            [_addUserBtn setTitle:@"Request" forState:UIControlStateNormal]; // To set the title
            [_addUserBtn setEnabled:YES];
            [self sendPush];
        }
    }];
    
}

- (void)sendPush {
    
    // Find devices associated with these users
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" equalTo:self.requestedUser];
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setMessage:[NSString stringWithFormat: @"%@ has requested contact.",  [PFUser currentUser].username]];
    [push sendPushInBackground];
    
}

- (IBAction)addUserButton:(id)sender {
    
    [self checkUserIsNotCurrentUser];
    [self.usernameSearchField resignFirstResponder];
    [_addUserBtn setTitle:@"Requesting..." forState:UIControlStateNormal]; // To set the title
    [_addUserBtn setEnabled:NO];
    
}
@end
