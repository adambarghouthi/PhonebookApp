//
//  ContactTableViewController.m
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-08-05.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import "ContactTableViewController.h"
#import "ContactTableViewCell.h"
#import "DetailViewController.h"
#import <Parse/Parse.h>

@interface ContactTableViewController () <UITableViewDataSource>

@property (strong,nonatomic) UIImage *profilePicture;

@property UIActivityIndicatorView *ac;
@property UIView *acView;
@property UIImage *setImage;

@end

@implementation ContactTableViewController

@synthesize contactsTable;
@synthesize ac;
@synthesize acView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contacts = [NSMutableArray array];
    self.contactRelation = [[PFUser currentUser] relationForKey:@"Contacts"];
    
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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self checkForRequests];
    [self retrieveContacts];
    self.acView.hidden = NO;
    [self.ac startAnimating];
}

- (void)checkForRequests {

    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"status" equalTo:@"pending"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object != nil) {
            [self.redBall setHidden:NO];
            NSLog(@"this is object %@", object);
        }
    }];
    
}

- (void)retrieveContacts {
    
    PFQuery *query = [self.contactRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.contacts removeAllObjects];
            [self.contacts addObjectsFromArray:objects];
            NSLog(@"contacts are %@", self.contacts);
            [self.contactsTable reloadData];
            [self.ac stopAnimating];
            self.acView.hidden = YES;
        }
        else {
            [self.ac stopAnimating];
            self.acView.hidden = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Connection Failure." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
        }
    }];
    


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];

    PFUser *user = [self.contacts objectAtIndex:indexPath.row];
    cell.usernameLabel.text = user.username;
    
    NSString *occupation = [user valueForKey:@"Occupation"];
    NSNumber *contactsNumber = [user valueForKey:@"ContactsNumber"];
    NSLog(@"%@", contactsNumber);
    NSString *contactsNumberString = [contactsNumber stringValue];
    NSLog(@"%@", contactsNumberString);
    
    if (occupation == NULL || [occupation isEqualToString:@""]) {
        occupation = @"Occupation Unavaliable";
    }
    
    cell.occupationLabel.text = occupation;
    cell.numberOfContacts.text = contactsNumberString;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"detail"]) {
        NSIndexPath *indexPath = [contactsTable indexPathForSelectedRow];
        PFObject *userAtIndex = [self.contacts objectAtIndex:indexPath.row];
        NSString *username = nil;
        NSString *fullName = nil;
        NSString *occupation = nil;
        NSString *code = nil;
        NSString *number = nil;
        NSString *country = nil;
        NSString *email = nil;
        NSString *twitter = nil;
        NSString *website = nil;
        PFFile *imgFile = [userAtIndex objectForKey:@"ProfilePic"];
        NSData *imgData = [imgFile getData];
        
        username = [userAtIndex objectForKey:@"username"];
        fullName = [userAtIndex objectForKey:@"FullName"];
        occupation = [userAtIndex objectForKey:@"Occupation"];
        code = [userAtIndex objectForKey:@"CountryCode"];
        number = [userAtIndex objectForKey:@"PhoneNumber"];
        country = [userAtIndex objectForKey:@"CountryName"];
        email = [userAtIndex objectForKey:@"email"];
        twitter = [userAtIndex objectForKey:@"TwitterHandle"];
        website = [userAtIndex objectForKey:@"WebsiteURL"];
        
        if (fullName == NULL || [fullName isEqualToString:@""]) {
            fullName = @"full name N/A";
        }
        if (occupation == NULL || [occupation isEqualToString:@""]) {
            occupation = @"occupation N/A";
        }
        if (email == NULL || [email isEqualToString:@""]) {
            email = @"email N/A";
        }
        if (website == NULL || [website isEqualToString:@""]) {
            website = @"website N/A";
        }
        if (imgFile == NULL || imgFile == nil) {
            [[segue destinationViewController] setProfilePictureImg:[UIImage imageNamed:@"userDefaultPic"]];
        }
        else {
            self.setImage = [UIImage imageWithData:imgData];
        }
        
        [[segue destinationViewController] setUsernameContent:username];
        [[segue destinationViewController] setFullNameContent:fullName];
        [[segue destinationViewController] setOccupationContent:occupation];
        [[segue destinationViewController] setCodeContent:code];
        [[segue destinationViewController] setPhoneNumberContent:number];
        [[segue destinationViewController] setCountryContent:country];
        [[segue destinationViewController] setEmailContent:email];
        [[segue destinationViewController] setWebsiteContent:website];
        [[segue destinationViewController] setProfilePictureImg:self.setImage];

    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end


