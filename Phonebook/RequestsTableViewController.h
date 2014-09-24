//
//  RequestsTableViewController.h
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-08-01.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RequestsTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *requestsTable;
@property (strong, nonatomic) NSMutableArray *requests;

@end
