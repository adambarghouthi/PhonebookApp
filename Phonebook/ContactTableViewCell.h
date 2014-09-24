//
//  ContactTableViewCell.h
//  Phonebook
//
//  Created by Adam Albarghouthi on 2014-08-09.
//  Copyright (c) 2014 Adam Albarghouthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *occupationLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberOfContacts;

@end
