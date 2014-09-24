//
//  ContactTableViewController.h
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-08-05.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ContactTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> 

@property (nonatomic, strong) PFRelation *contactRelation;
@property (strong, nonatomic) NSMutableArray *contacts;
@property (strong, nonatomic) IBOutlet UITableView *contactsTable;
@property (strong, nonatomic) IBOutlet UIImageView *redBall;

@end
