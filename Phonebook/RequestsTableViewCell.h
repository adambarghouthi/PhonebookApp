//
//  RequestsTableViewCell.h
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-08-01.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RequestsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *acceptBtn;
@property (strong, nonatomic) IBOutlet UIButton *declineBtn;

@end
